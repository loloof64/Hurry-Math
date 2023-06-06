import 'package:hurry_math/models/exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciceNotifier extends StateNotifier<Exercise?> {
  ExerciceNotifier() : super(null);

  void loadExercise(Exercise exercise) {
    state = exercise;
  }

  void answerCurrentQuestion(int userAnswer) {
    state = state?.copyAnsweringCurrentQuestion(userAnswer);
  }

  void setSpentTimeInDeciSeconds(int timeSpentDeciSeconds) {
    state = state?.copyWithSpentTimeInDeciSeconds(timeSpentDeciSeconds);
  }

  bool get isOver => state?.isOver ?? true;
}

final exerciseProvider = StateNotifierProvider<ExerciceNotifier, Exercise?>(
  (ref) => ExerciceNotifier(),
);
