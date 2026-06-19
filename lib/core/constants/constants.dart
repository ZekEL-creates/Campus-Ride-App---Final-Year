import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

String googleMapKey = "AIzaSyBdXzqce9VATI6XNyEqu4KlnDI2D7OA7_k";
String updatePropertyName = '';
Position? position;
QuerySnapshot<Map<String, dynamic>>? locations;
