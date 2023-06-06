import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hurry_math/algorithms/exercise_generator.dart';
import 'package:hurry_math/models/exercise.dart';
import 'package:hurry_math/providers/exercice.dart';
import 'package:hurry_math/screens/exercise.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _gotoSimpleExercise(BuildContext context, WidgetRef ref) async {
    ref.read(exerciseProvider.notifier).loadExercise(
          Exercise(
            questionsList: generateSimpleExercise(),
          ),
        );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const ExerciseScreen()),
    );
  }

  void _gotoMissingOperandExercise(BuildContext context, WidgetRef ref) async {
    ref.read(exerciseProvider.notifier).loadExercise(
          Exercise(
            questionsList: generateMissingOperandExercise(),
          ),
        );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const ExerciseScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your exercise.'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _gotoSimpleExercise(context, ref),
              child: const Text('New simple exercise'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _gotoMissingOperandExercise(context, ref),
              child: const Text('New missing operand exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
