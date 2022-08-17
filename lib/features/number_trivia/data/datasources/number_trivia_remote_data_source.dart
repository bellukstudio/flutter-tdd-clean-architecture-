import 'package:flutter_tdd_learn/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// calls the url endpoint
  ///
  /// throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// calls the url endpoint
  ///
  /// throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
