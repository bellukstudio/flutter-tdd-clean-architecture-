import 'package:flutter_tdd_learn/core/platform/network_info.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
//mocks
import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late NumberTriviaLocalDataSource mockLocalDataSource =
      MockNumberTriviaLocalDataSource();
  late NumberTriviaRemoteDataSource mockremoteDataSource =
      MockNumberTriviaRemoteDataSource();
  late NetworkInfo mockNetworkInfo = MockNetworkInfo();

  setUp(() {
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockremoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockremoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
  });
}
