import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    const commonTextStyle = TextStyle(fontSize: 22.0);

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
        ),
      ),
    );
  }
}
