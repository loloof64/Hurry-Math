import 'package:hurry_math/algorithms/simple_exercise_generator.dart';
import 'package:hurry_math/models/question.dart';

class Exercise {
  Exercise({
    required this.questionsList,
  });

  Exercise.newSimpleExercise() : questionsList = generateSimpleExercise();

  final List<Question> questionsList;
}
