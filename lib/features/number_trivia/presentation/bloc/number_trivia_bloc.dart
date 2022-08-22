import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_tdd_learn/core/util/input_converter.dart';
import 'package:flutter_tdd_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_learn/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_learn/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MSG = 'Server Failure';
const String CACHE_FAILURE_MSG = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MSG =
    'Invalid Input - The Number must be a positive integer or zeron';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concreteNumberTrivia,
    required GetRandomNumberTrivia randomNumberTrivia,
    required this.inputConverter,
    // ignore: unnecessary_null_comparison
  })  : assert(concreteNumberTrivia != null),
        // ignore: unnecessary_null_comparison
        assert(randomNumberTrivia != null),
        getConcreteNumberTrivia = concreteNumberTrivia,
        getRandomNumberTrivia = randomNumberTrivia,
        super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        emit(inputEither.fold(
            (failure) => const Error(message: INVALID_INPUT_FAILURE_MSG),
            (integer) => throw UnimplementedError()));
      }
    });
  }
}
