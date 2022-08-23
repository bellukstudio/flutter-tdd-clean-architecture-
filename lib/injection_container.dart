import 'package:flutter_tdd_learn/core/network/network_info.dart';
import 'package:flutter_tdd_learn/core/util/input_converter.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_learn/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_learn/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_learn/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_learn/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_learn/features/number_trivia/presentation/bloc/bloc..dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;
Future<void> init() async {
  //! Feature - number trivia
  //bloc
  sl.registerFactory(() => NumberTriviaBloc(
      concreteNumberTrivia: sl(),
      randomNumberTrivia: sl(),
      inputConverter: sl()));
  //use case
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  //repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  //data
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(preferences: sl()));
  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
