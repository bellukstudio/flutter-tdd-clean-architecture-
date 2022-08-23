import 'dart:convert';

import 'package:flutter_tdd_learn/core/error/exeptions.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientSuccess404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request an a URL with number being to endpoint and with application/json header',
        () async {
      ////arrange
      setUpMockHttpClientSuccess200();
      ////act
      dataSourceImpl.getConcreteNumberTrivia(tNumber);

      ////assert
      verify(mockHttpClient.get(Uri.parse('http://numberapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });
    test('should perform a GET request when response code 200', () async {
      ////arrange
      setUpMockHttpClientSuccess200();
      ////act
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);

      ////assert
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      ////arrange
      setUpMockHttpClientSuccess404();
      ////act
      final call = dataSourceImpl.getConcreteNumberTrivia;
      ////assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request an a URL with random number being to endpoint and with application/json header',
        () async {
      ////arrange
      setUpMockHttpClientSuccess200();
      ////act
      dataSourceImpl.getRandomNumberTrivia();

      ////assert
      verify(mockHttpClient.get(Uri.parse('http://numberapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });
    test('should perform a GET request when response code 200', () async {
      ////arrange
      setUpMockHttpClientSuccess200();
      ////act
      final result = await dataSourceImpl.getRandomNumberTrivia();

      ////assert
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      ////arrange
      setUpMockHttpClientSuccess404();
      ////act
      final call = dataSourceImpl.getRandomNumberTrivia;
      ////assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
