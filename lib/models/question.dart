import 'dart:math';

import 'package:flutter/material.dart';

final _randomizer = Random();

const hole = '___';

enum Operator { add, sub, mul, div }

const Map<Operator, String> operatorsLabels = {
  Operator.add: '+',
  Operator.sub: '-',
  Operator.mul: '*',
  Operator.div: '/'
};

class Question {
  Question({
    this.operand_1,
    this.operand_2,
    required this.operator,
    this.result,
    required this.expectedAnswer,
  }) {
    int nullCount = 0;
    if (operand_1 == null) nullCount++;
    if (operand_2 == null) nullCount++;
    if (result == null) nullCount++;
    if (nullCount != 1) {
      throw Exception(
        'Please check that one and only one parameter is null',
      );
    }
  }

  void seUserAnswer(int answer) {
    userAnswer = answer;
  }

  bool get isCorrectedAnswered => userAnswer == expectedAnswer;

  bool get answered => userAnswer != null;

  RichText getRepresentation(double fontSize) {
    final replacement = userAnswer == null
        ? hole
        : userAnswer == expectedAnswer
            ? userAnswer.toString()
            : '$userAnswer ($expectedAnswer)';
    final replacementColor = userAnswer == null
        ? Colors.blue
        : userAnswer == expectedAnswer
            ? Colors.green
            : Colors.red;
    if (result == null && operand_1 != null && operand_2 != null) {
      return _getResultMaskedRepresentation(
        fontSize,
        replacement,
        replacementColor,
      );
    }
    if (operand_1 == null && operand_2 != null && result != null) {
      return _getFirstOperandMaskedRepresentation(
        fontSize,
        replacement,
        replacementColor,
      );
    }
    if (operand_2 == null && operand_1 != null && result != null) {
      return _getSecondOperandMaskedRepresentation(
        fontSize,
        replacement,
        replacementColor,
      );
    }
    throw Exception('Should never reach this line !');
  }

  RichText _getResultMaskedRepresentation(
    double fontSize,
    String replacement,
    Color replacementColor,
  ) {
    return RichText(
      softWrap: false,
      text: TextSpan(
        text: '$operand_1 ${operatorsLabels[operator]} $operand_2 = ',
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
        ),
        children: [
          TextSpan(
            text: replacement,
            style: TextStyle(
              color: replacementColor,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  RichText _getFirstOperandMaskedRepresentation(
    double fontSize,
    String replacement,
    Color replacementColor,
  ) {
    return RichText(
      softWrap: false,
      text: TextSpan(
        text: replacement,
        style: TextStyle(
          color: replacementColor,
          fontSize: fontSize,
        ),
        children: [
          TextSpan(
            text: ' ${operatorsLabels[operator]} $operand_2 = $result',
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  RichText _getSecondOperandMaskedRepresentation(
    double fontSize,
    String replacement,
    Color replacementColor,
  ) {
    return RichText(
      softWrap: false,
      text: TextSpan(
        text: '$operand_1 ${operatorsLabels[operator]} ',
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
        ),
        children: [
          TextSpan(
            text: replacement,
            style: TextStyle(
              color: replacementColor,
              fontSize: fontSize,
            ),
          ),
          TextSpan(
            text: ' = $result',
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  @override
  String toString() {
    final op1 = operand_1 ?? '?';
    final op2 = operand_2 ?? '?';
    final res = result ?? '?';
    final optr = operatorsLabels[operator];
    return 'Question($op1 $optr $op2 = $res {$userAnswer})';
  }

  final int? operand_1;
  final int? operand_2;
  final int? result;
  final Operator operator;
  final int expectedAnswer;
  int? userAnswer;
}

class Operation {
  Operation({
    required this.operand_1,
    required this.operand_2,
    required this.result,
    required this.operator,
  });

  factory Operation.randomAddition() {
    final operand_1 = _randomOperand();
    final operand_2 = _randomOperand();
    final result = operand_1 + operand_2;
    const operator = Operator.add;

    return Operation(
      operand_1: operand_1,
      operand_2: operand_2,
      result: result,
      operator: operator,
    );
  }

  factory Operation.randomSubstraction() {
    final reversedOperation = Operation.randomAddition();
    final reversedOrder = _randomizer.nextBool();
    if (reversedOrder) {
      final operand_1 = reversedOperation.result;
      final operand_2 = reversedOperation.operand_2;
      final result = reversedOperation.operand_1;
      const operator = Operator.sub;

      return Operation(
        operand_1: operand_1,
        operand_2: operand_2,
        result: result,
        operator: operator,
      );
    } else {
      final operand_1 = reversedOperation.result;
      final operand_2 = reversedOperation.operand_1;
      final result = reversedOperation.operand_2;
      const operator = Operator.sub;

      return Operation(
        operand_1: operand_1,
        operand_2: operand_2,
        result: result,
        operator: operator,
      );
    }
  }

  factory Operation.randomMultiplication() {
    final operand_1 = _randomOperand();
    final operand_2 = _randomOperand();
    final result = operand_1 * operand_2;
    const operator = Operator.mul;

    return Operation(
      operand_1: operand_1,
      operand_2: operand_2,
      result: result,
      operator: operator,
    );
  }

  factory Operation.randomDivision() {
    final reversedOperation = Operation.randomMultiplication();
    final reversedOrder = _randomizer.nextBool();
    if (reversedOrder) {
      final operand_1 = reversedOperation.result;
      final operand_2 = reversedOperation.operand_2;
      final result = reversedOperation.operand_1;
      const operator = Operator.div;

      return Operation(
        operand_1: operand_1,
        operand_2: operand_2,
        result: result,
        operator: operator,
      );
    } else {
      final operand_1 = reversedOperation.result;
      final operand_2 = reversedOperation.operand_1;
      final result = reversedOperation.operand_2;
      const operator = Operator.div;

      return Operation(
        operand_1: operand_1,
        operand_2: operand_2,
        result: result,
        operator: operator,
      );
    }
  }

  final int operand_1;
  final int operand_2;
  final int result;
  final Operator operator;
}

int _randomOperand() => _randomizer.nextInt(9) + 1;
