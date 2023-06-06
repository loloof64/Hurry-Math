import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hurry_math/providers/exercice.dart';
import 'package:hurry_math/screens/score.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ScrollOffsetController _scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener _scrollOffsetListener =
      ScrollOffsetListener.create();

  var _decisecondsSpent = 0;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _decisecondsSpent++;
      });
    });
  }

  void _answerQuestion(String text) {
    final enteredAnswer = int.tryParse(text);
    final currentQuestionIndex = ref.read(exerciseProvider)!.currentIndex;
    final isANumber = enteredAnswer != null;
    if (isANumber) {
      ref.read(exerciseProvider.notifier).answerCurrentQuestion(enteredAnswer);
      final isOver = ref.read(exerciseProvider)!.isOver;
      if (isOver) {
        setState(() {
          _timer.cancel();
        });
        ref
            .read(exerciseProvider.notifier)
            .setSpentTimeInDeciSeconds(_decisecondsSpent);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const ScoreScreen(),
          ),
        );
      } else {
        _itemScrollController.scrollTo(
          index: currentQuestionIndex,
          duration: const Duration(
            milliseconds: 150,
          ),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = ref.watch(exerciseProvider);
    final timeString =
        '${Duration(milliseconds: 100 * _decisecondsSpent).inSeconds} s';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: exercise == null
          ? const Center(
              child: Text('No exercise loaded yet.'),
            )
          : Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Text(timeString),
                ),
                Flexible(
                  flex: 9,
                  child: ScrollablePositionedList.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemScrollController: _itemScrollController,
                    scrollOffsetController: _scrollOffsetController,
                    itemPositionsListener: _itemPositionsListener,
                    scrollOffsetListener: _scrollOffsetListener,
                    itemCount: exercise.questionsList.length,
                    itemBuilder: (ctx, index) {
                      final question = exercise.questionsList[index];
                      return LayoutBuilder(builder: (ctx, constraints) {
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
                      });
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: _AnswerInput(
                    onAnswerQuestion: (text) => _answerQuestion(text),
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
      (questionIndex + 1) % 5 == 0
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
