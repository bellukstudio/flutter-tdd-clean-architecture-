import 'dart:convert';

import 'package:flutter_tdd_learn/core/error/exeptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_tdd_learn/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences preferences;
  NumberTriviaLocalDataSourceImpl({
    required this.preferences,
  });

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache) {
    return preferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = preferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
