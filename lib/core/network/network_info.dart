import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  // final Connectivity connectionChecker;
  final InternetConnectionChecker internetConnectionChecker;
  NetworkInfoImpl(
    // this.connectionChecker,
    this.internetConnectionChecker,
  );
  @override
  Future<bool> get isConnected {
    return internetConnectionChecker.hasConnection;
  }
}
