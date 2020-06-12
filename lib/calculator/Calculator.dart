abstract class AbstractBasicCalculator {
  double add(double firstNumber, double secondNumber);

  double subtract(double firstNumber, double secondNumber);
}

class Calculator {
  final AbstractBasicCalculator basicCalculator;

  Calculator(this.basicCalculator);

  double add(double firstNumber, double secondNumber) {
    return basicCalculator.add(firstNumber, secondNumber);
  }

  double subtract(double firstNumber, double secondNumber) {
    return basicCalculator.subtract(firstNumber, secondNumber);
  }

  double product(double multiplicand, double multiplier) {
    double sum = 0;
    for (double index = 0; index < multiplier; index++) {
      sum = basicCalculator.add(sum, multiplicand);
    }
    return sum;
  }

  double quotient(double firstNumber, double secondNumber) {
    if(secondNumber==0){
      throw ArgumentError('Divided by Zero');
    }
    double quotient = 0;
    while (firstNumber >= secondNumber) {
      quotient++;
      firstNumber = basicCalculator.subtract(firstNumber, secondNumber);
    }
    return quotient;
  }

  double reminder(double dividend, double divisor) {
    double quotient = 0;
    while (dividend > divisor) {
      quotient++;
      dividend = basicCalculator.subtract(dividend, divisor);
    }
    return dividend;
  }
}
