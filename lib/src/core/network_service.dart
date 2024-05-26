import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  final Connectivity connectivity;
  NetworkService({required this.connectivity});
  Future<bool> hasInternetConnection() async {
    // Check if there is a network connection
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No network connection
      return false;
    }

    // If there is a network connection, perform a small network request
    try {
      // final result = await http.get(
      //   Uri.parse('https://www.google.com'),
      //   headers: {
      //     'Access-Control-Allow-Origin': '*',
      //     'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      //     'Access-Control-Allow-Headers': 'Content-Type',
      //     'Content-Type': "text/json",
      //   },
      // ).timeout(
      //   Duration(seconds: 5),
      //   onTimeout: () => http.Response('Error', 500),
      // );

      FirebaseFirestore.instance.collection("users").runtimeType;

      // if (result.statusCode == 200) {
      // Internet connection is present
      return true;
      // }
    } catch (e) {
      // Handle error
      return false;
    }

    // No internet connection
  }
}
