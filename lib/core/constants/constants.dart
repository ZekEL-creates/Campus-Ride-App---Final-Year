import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ridesharingapp/services/storage_exceptions.dart';

String googleMapKey = "AIzaSyBdXzqce9VATI6XNyEqu4KlnDI2D7OA7_k";
String updatePropertyName = '';
Position? position;
QuerySnapshot<Map<String, dynamic>>? locations;

Future<void> checkConnection() async {
  final result = await Connectivity().checkConnectivity();

  if (result.contains(ConnectivityResult.none)) {
    throw NetworkException();
  }
}
