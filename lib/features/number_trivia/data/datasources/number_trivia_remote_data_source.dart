import 'dart:convert';

import 'package:flutter_tdd_learn/core/error/exeptions.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_tdd_learn/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// calls the url endpoint
  ///
  /// throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  /// calls the url endpoint
  ///
  /// throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) async {
    return _getTriviaUrl('http://numberapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getTriviaUrl('http://numberapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
