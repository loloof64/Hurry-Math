import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hurry_math/models/exercise.dart';
import 'package:hurry_math/providers/exercice.dart';

class ScoreScreen extends ConsumerWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = ref.watch(exerciseProvider)!;

    final correctAnswersCount = exercise.correctlyAnsweredCount;
    final questionsCount = exercise.questionsList.length;
    final points = exercise.score;
    final duration = exercise.spentTimeString;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your result'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: ScoreText(
                correctAnswersCount: correctAnswersCount,
                questionsCount: questionsCount,
                points: points,
                duration: duration,
              ),
            ),
            Flexible(
              flex: 6,
              child: QuestionsSummary(
                exercise: exercise,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreText extends StatelessWidget {
  const ScoreText({
    Key? key,
    required this.correctAnswersCount,
    required this.questionsCount,
    required this.points,
    required this.duration,
  }) : super(key: key);

  final int correctAnswersCount;
  final int questionsCount;
  final int points;
  final String duration;

  @override
  Widget build(BuildContext context) {
    final commonTextStyle = TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.011,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Statistics',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'You solved $correctAnswersCount out of $questionsCount.',
          style: commonTextStyle,
        ),
        Text(
          'You took $duration.',
          style: commonTextStyle,
        ),
        Text(
          'You got a score of $points.',
          style: commonTextStyle,
        )
      ],
    );
  }
}

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Questions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          for (final question in exercise.questionsList)
            question.getRepresentation(
              MediaQuery.of(context).size.width * 0.02,
            )
        ],
      ),
    );
  }
}
