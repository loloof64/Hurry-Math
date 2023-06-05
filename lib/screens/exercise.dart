import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hurry_math/providers/exercice.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key});

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    final exercise = ref.watch(exerciseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: exercise == null
            ? const Center(
                child: Text('No exercise loaded yet.'),
              )
            : ListView.builder(
                itemCount: exercise.questionsList.length,
                itemBuilder: (ctx, index) {
                  return Text(
                    exercise.questionsList[index].representation,
                  );
                },
              ),
      ),
    );
  }
}
