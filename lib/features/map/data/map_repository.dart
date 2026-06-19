import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/core/constants/constants.dart';

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

  Future<QuerySnapshot<Map<String, dynamic>>> getCampusLocations() {
    try {
      return FirebaseFirestore.instance.collection('campus_locations').get();
    } on Exception catch (_) {
      throw CouldNotGetDataException();
    }
  }

  Future<List<LatLng>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    PolylinePoints points = PolylinePoints(apiKey: googleMapKey);
    final result = await points.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(startLat, startLng),
        destination: PointLatLng(endLat, endLng),
        mode: TravelMode.driving,
      ),
    );
    return result.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
}
