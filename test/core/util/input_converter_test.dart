import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_learn/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('string to unsignedInt', () {
    test(
        'should return an integer when the string represent an unsigned integer',
        () async {
      ////arrange
      const str = '123';
      ////act
      final result = inputConverter.stringToUnsignedInteger(str);

      ////assert
      expect(result, const Right(123));
    });

    test('should return Failure when string is not integer', () async {
      ////arrange
      const str = 'abc';
      ////act
      final result = inputConverter.stringToUnsignedInteger(str);

      ////assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return Failure when string is negative integer', () async {
      ////arrange
      const str = '-123';
      ////act
      final result = inputConverter.stringToUnsignedInteger(str);

      ////assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
