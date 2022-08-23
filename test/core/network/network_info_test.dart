import 'package:flutter_tdd_learn/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'network_info_test.mocks.dart';

// @GenerateMocks([Connectivity])
@GenerateMocks([InternetConnectionChecker])
void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();
  late final NetworkInfoImpl networkInfoImpl;
  // late final MockConnectivity mockConnectivity;
  late final MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    // mockConnectivity = MockConnectivity();
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test('should check have connection internet or not', () async {
      ////arrange
      final tHasConenctionFuture = Future.value(true);
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConenctionFuture);
      ////act
      final result = networkInfoImpl.isConnected;
      ////assert
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, tHasConenctionFuture);
    });
  });
}
