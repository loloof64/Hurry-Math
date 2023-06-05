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

  String get representation {
    if (result == null && operand_1 != null && operand_2 != null) {
      return '$operand_1 ${operatorsLabels[operator]} $operand_2 = $hole';
    }
    if (operand_1 == null && operand_2 != null && result != null) {
      return '$hole ${operatorsLabels[operator]} $operand_2 = $result';
    }
    if (operand_2 == null && operand_1 != null && result != null) {
      return '$operand_1 ${operatorsLabels[operator]} $hole = $result';
    }
    throw Exception('Should never reach this line !');
  }

  @override
  String toString() {
    return 'Question('
        'operand_1 = $operand_1,'
        ' operand_2 = $operand_2,'
        ' operator = $operator,'
        ' result = $result,'
        ' expectedAnswer = $expectedAnswer'
        ')';
  }

  final int? operand_1;
  final int? operand_2;
  final int? result;
  final Operator operator;
  final int expectedAnswer;
}
