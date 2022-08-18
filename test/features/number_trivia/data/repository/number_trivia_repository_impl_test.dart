import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_learn/core/error/exeptions.dart';
import 'package:flutter_tdd_learn/core/error/failures.dart';
import 'package:flutter_tdd_learn/core/platform/network_info.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
//mocks
import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDataSource])
@GenerateMocks([NumberTriviaLocalDataSource])
@GenerateMocks([NetworkInfo])
void main() {
  late final NumberTriviaRepositoryImpl repositoryImpl;
  late final MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late final MockNumberTriviaLocalDataSource mockLocalDataSource;
  late final MockNetworkInfo mockNetworkInfo;

  const int tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(number: tNumber, text: 'test trivia');
  const tNumberRandomTriviaModel =
      NumberTriviaModel(number: 123, text: 'test trivia');
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;
  const NumberTrivia tRandomNumberTrivia = tNumberRandomTriviaModel;

  setUpAll(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);

    when(mockRemoteDataSource.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => tNumberTriviaModel);

    when(mockRemoteDataSource.getRandomNumberTrivia())
        .thenAnswer((_) async => tNumberRandomTriviaModel);
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    //to make test manageable create variables

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should return cache  data local when the call to remote data source is successfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure data when the call to remote data source is unsuccessfull',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        // verifyZeroInteractions(mockLocalDataSource);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        // verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return cached data failure when is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        // verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    //to make test manageable create variables

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberRandomTriviaModel);
        //act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tRandomNumberTrivia)));
      });

      test(
          'should return cache  data local when the call to remote data source is successfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberRandomTriviaModel);
        //act
        await repositoryImpl.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberRandomTriviaModel));
      });
      test(
          'should return server failure data when the call to remote data source is unsuccessfull',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.getRandomNumberTrivia();
        // assert
        // verifyZeroInteractions(mockLocalDataSource);
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberRandomTriviaModel);
        //act
        final result = await repositoryImpl.getRandomNumberTrivia();

        //assert
        // verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tRandomNumberTrivia)));
      });

      test('should return cached data failure when is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //assert
        // verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
