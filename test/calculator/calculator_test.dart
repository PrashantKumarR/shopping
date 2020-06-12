import 'package:flutter_shop/calculator/Calculator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockedBasicCalculator extends Mock implements AbstractBasicCalculator {}

void main() {
  Calculator SUT;
  AbstractBasicCalculator abstractBasicCalculatorMock;

  group('Calculator.add', () {
    Calculator SUT;
    MockedBasicCalculator mockedBasicCalculator;
    setUp(() {
      mockedBasicCalculator = MockedBasicCalculator();
      SUT = Calculator(mockedBasicCalculator);
    });

    test('add should return sum of the two number', () {
      when(mockedBasicCalculator.add(10, 20)).thenReturn(30);
      double sum = SUT.add(10, 20);
      expect(sum, 30);
    });

    test('add should interact with add method from basic calculator API', () {
      SUT.add(10, 20);
      List<dynamic> argumentCaptured =
          verify(mockedBasicCalculator.add(captureAny, captureAny)).captured;
      expect(argumentCaptured[0], 10);
      expect(argumentCaptured[1], 20);
    });

    test('should return number of ’times  basic calculator API is called', () {
      SUT.add(10, 20);
      SUT.add(10, 20);
      verify(mockedBasicCalculator.add(captureAny, captureAny)).called(2);
    });
  });

  group('Calculator.product', () {
    Calculator SUT;
    AbstractBasicCalculator fakeAbstractBasicCalculatorTD;
    setUp(() {
      fakeAbstractBasicCalculatorTD = FakeAbstractBasicCalculatorTD();
      SUT = Calculator(fakeAbstractBasicCalculatorTD);
    });

    test('should return number product of two numbers', () {
      double result = SUT.product(2, 5);
      expect(result, 10);
    });
  });

  group('Calculator.quotient', () {
    Calculator SUT;
    AbstractBasicCalculator fakeAbstractBasicCalculatorTD;
    setUp(() {
      fakeAbstractBasicCalculatorTD = FakeAbstractBasicCalculatorTD();
      SUT = Calculator(fakeAbstractBasicCalculatorTD);
    });

    test('should return quotient of division operation', () {
      double result = SUT.quotient(20, 5);
      expect(result, 4);
    });

    test('should throw an exception if divisor is zero', () {
      expect(() => SUT.quotient(20, 0), throwsA(isA<ArgumentError>()));
    });
  });
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>> Test Double Starts Here >>>>>>>>>>>>>>>>>>>>>>>

class FakeAbstractBasicCalculatorTD implements AbstractBasicCalculator {
  @override
  double add(double firstNumber, double secondNumber) {
    return firstNumber + secondNumber;
  }

  @override
  double subtract(double firstNumber, double secondNumber) {
    return firstNumber - secondNumber;
  }
}
// <<<<<<<<<<<<<<<<<<<<<<<<<< Test Double Ends Here <<<<<<<<<<<<<<<<<<<<<<<<<<
