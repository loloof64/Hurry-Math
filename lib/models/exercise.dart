import 'package:hurry_math/algorithms/simple_exercise_generator.dart';
import 'package:hurry_math/models/question.dart';

class Exercise {
  Exercise({
    required this.questionsList,
  });

  Exercise.newSimpleExercise() : questionsList = generateSimpleExercise();

  int get currentIndex =>
      questionsList.indexWhere((question) => !question.answered);

  Exercise answerCurrentQuestion(int userAnswer) {
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
}
