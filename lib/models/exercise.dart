import 'package:hurry_math/algorithms/simple_exercise_generator.dart';
import 'package:hurry_math/models/question.dart';

class Exercise {
  Exercise({
    required this.questionsList,
    this.timeSpentDeciSeconds = 0,
  });

  Exercise.newSimpleExercise()
      : questionsList = generateSimpleExercise(),
        timeSpentDeciSeconds = 0;

  bool get isOver => currentIndex >= questionsList.length || currentIndex == -1;

  int get currentIndex =>
      questionsList.indexWhere((question) => !question.answered);

  int get correctlyAnsweredCount =>
      questionsList.where((question) => question.isCorrectedAnswered).length;

  int get score {
    return correctlyAnsweredCount * 100 - timeSpentDeciSeconds;
  }

  Duration get spentTime => Duration(milliseconds: timeSpentDeciSeconds * 100);

  String get spentTimeString {
    return spentTime.inSeconds > 60
        ? "${spentTime.inMinutes.remainder(60)}m and ${(spentTime.inSeconds.remainder(60))}s"
        : "${spentTime.inSeconds.remainder(60)}s";
  }

  Exercise copyWithSpentTimeInDeciSeconds(int timeSpentDeciSeconds) {
    return Exercise(
        questionsList: questionsList,
        timeSpentDeciSeconds: timeSpentDeciSeconds);
  }

  Exercise copyAnsweringCurrentQuestion(int userAnswer) {
    final interestIndex = currentIndex;
    if (interestIndex == -1) return this;

    var currentQuestion = questionsList[interestIndex];
    currentQuestion.seUserAnswer(userAnswer);

    List<Question> result = [];
    for (var i = 0; i < interestIndex; i++) {
      result.add(questionsList[i]);
    }
    result.add(currentQuestion);
    for (var i = interestIndex + 1; i < questionsList.length; i++) {
      result.add(questionsList[i]);
    }

    return Exercise(questionsList: result);
  }

  final List<Question> questionsList;
  final int timeSpentDeciSeconds;
}
