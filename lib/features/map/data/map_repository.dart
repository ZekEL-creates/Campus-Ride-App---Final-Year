import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ridesharingapp/features/map/data/map_exceptions.dart';

class MapRepository {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<QuerySnapshot> getCampusLocations() {
    return FirebaseFirestore.instance.collection('campus_locations').get();
  }
}
