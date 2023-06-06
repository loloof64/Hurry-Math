import 'dart:math';

import 'package:hurry_math/models/question.dart';

final _randomizer = Random();

List<Question> generateSimpleExercise() {
  const questionsCount = 30;
  List<Question> result = [];
  for (var i = 0; i < questionsCount; i++) {
    result.add(_generateSimpleQuestion());
  }
  return result;
}

List<Question> generateMissingOperandExercise() {
  const questionsCount = 30;
  List<Question> result = [];
  for (var i = 0; i < questionsCount; i++) {
    result.add(_generateMissingOperandQuestion());
  }
  return result;
}

Question _generateSimpleQuestion() {
  final operatorIndex = _randomizer.nextInt(4);
  Operation generatedOperation;
  switch (operatorIndex) {
    case 0:
      generatedOperation = Operation.randomAddition();
      break;
    case 1:
      generatedOperation = Operation.randomSubstraction();
      break;
    case 2:
      generatedOperation = Operation.randomMultiplication();
      break;
    case 3:
      generatedOperation = Operation.randomDivision();
      break;
    default:
      {
        generatedOperation = Operation.randomAddition();
      }
  }

  return Question(
    operator: generatedOperation.operator,
    expectedAnswer: generatedOperation.result,
    operand_1: generatedOperation.operand_1,
    operand_2: generatedOperation.operand_2,
    result: null,
  );
}

Question _generateMissingOperandQuestion() {
  final operatorIndex = _randomizer.nextInt(4);
  Operation generatedOperation;
  switch (operatorIndex) {
    case 0:
      generatedOperation = Operation.randomAddition();
      break;
    case 1:
      generatedOperation = Operation.randomSubstraction();
      break;
    case 2:
      generatedOperation = Operation.randomMultiplication();
      break;
    case 3:
      generatedOperation = Operation.randomDivision();
      break;
    default:
      {
        generatedOperation = Operation.randomAddition();
      }
  }

  final missingOperand1 = _randomizer.nextBool();

  return Question(
    operator: generatedOperation.operator,
    expectedAnswer: missingOperand1
        ? generatedOperation.operand_1
        : generatedOperation.operand_2,
    operand_1: missingOperand1 ? null : generatedOperation.operand_1,
    operand_2: missingOperand1 ? generatedOperation.operand_2 : null,
    result: generatedOperation.result,
  );
}
