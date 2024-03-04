import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> verifyConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}
