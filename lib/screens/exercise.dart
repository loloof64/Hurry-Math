import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hurry_math/providers/exercice.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key});

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  final _answerController = TextEditingController();

  void _answerQuestion() {
    final enteredAnswer = int.tryParse(_answerController.text.trim());
    final isANumber = enteredAnswer != null;
    if (isANumber) {
      _answerController.clear();
      ref.read(exerciseProvider.notifier).answerCurrentQuestion(enteredAnswer);
    } else {
      _answerController.clear();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

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
            : Column(
                children: [
                  Flexible(
                    flex: 9,
                    child: Wrap(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        for (final question in exercise.questionsList)
                          LayoutBuilder(
                            builder: (ctx2, constraints) {
                              return question.getRepresentation(
                                constraints.biggest.width * 0.12,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onEditingComplete: _answerQuestion,
                            controller: _answerController,
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            enableSuggestions: false,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _answerQuestion,
                          icon: const Icon(Icons.send),
                          label: const Text('Answer'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
