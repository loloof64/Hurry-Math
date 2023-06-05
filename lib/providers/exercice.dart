import 'package:hurry_math/models/exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciceNotifier extends StateNotifier<Exercise?> {
  ExerciceNotifier() : super(null);

  void loadExercise(Exercise exercise) {
    state = exercise;
  }

  void answerCurrentQuestion(int userAnswer) {
    state = state?.answerCurrentQuestion(userAnswer);
  }
}

final exerciseProvider = StateNotifierProvider<ExerciceNotifier, Exercise?>(
  (ref) => ExerciceNotifier(),
);
