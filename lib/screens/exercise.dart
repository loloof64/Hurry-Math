import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hurry_math/models/question.dart';
import 'package:hurry_math/providers/exercice.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: const _ExerciceWidget(),
    );
  }
}

class _ExerciceWidget extends ConsumerStatefulWidget {
  const _ExerciceWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<_ExerciceWidget> createState() => __ExerciceWidgetState();
}

class __ExerciceWidgetState extends ConsumerState<_ExerciceWidget> {
  void _answerQuestion(String text) {
    final enteredAnswer = int.tryParse(text);
    final isANumber = enteredAnswer != null;
    if (isANumber) {
      ref.read(exerciseProvider.notifier).answerCurrentQuestion(enteredAnswer);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final exercise = ref.watch(exerciseProvider);
    final currentQuestionIndex = exercise?.currentIndex;

    const lineSpacing = 100.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: exercise == null
          ? const Center(
              child: Text('No exercise loaded yet.'),
            )
          : Column(
              children: [
                Flexible(
                  flex: 9,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exercise.questionsList.length,
                    itemBuilder: (ctx, index) {
                      final question = exercise.questionsList[index];
                      return LayoutBuilder(
                        builder: (ctx2, constraints) {
                          final fontSize = constraints.biggest.width * 0.12;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: _QuestionMarker(
                                  questionIndex: index,
                                  fontSize: fontSize,
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: question.getRepresentation(
                                  fontSize,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: _AnswerInput(
                    onAnswerQuestion: _answerQuestion,
                  ),
                )
              ],
            ),
    );
  }
}

class _QuestionMarker extends StatelessWidget {
  const _QuestionMarker({
    Key? key,
    required this.questionIndex,
    required this.fontSize,
  }) : super(key: key);

  final int questionIndex;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      questionIndex % 4 == 0 && questionIndex > 0
          ? 'Q${(questionIndex + 1).toString().padLeft(2, '0')}'
          : '',
      style: TextStyle(
        fontSize: fontSize,
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}

class _AnswerInput extends StatefulWidget {
  const _AnswerInput({
    Key? key,
    required this.onAnswerQuestion,
  }) : super(key: key);

  final void Function(String input) onAnswerQuestion;

  @override
  State<_AnswerInput> createState() => _AnswerInputState();
}

class _AnswerInputState extends State<_AnswerInput> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onEditingComplete: () {
              widget.onAnswerQuestion(_answerController.text.trim());
              _answerController.clear();
            },
            autofocus: true,
            controller: _answerController,
            keyboardType: TextInputType.number,
            autocorrect: false,
            enableSuggestions: false,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
