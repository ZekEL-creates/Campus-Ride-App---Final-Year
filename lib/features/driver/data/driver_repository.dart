import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/core/enum/status.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';
import 'package:ridesharingapp/services/firebase_storage_service.dart';

class DriverRepository {
  final _storage = FirebaseStorageService();

  Future<void> goOnline({
    required AppUser driver,
    required LatLng location,
  }) async {
    await _storage.create(
      collectionName: 'drivers',
      id: driver.id,
      data: {
        'isOnline': true,
        'isAvailable': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'currentLocation': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
      },
      options: SetOptions(merge: true),
    );
  }

  Future<void> goOffline({required AppUser driver}) async {
    await _storage.updateData(
      collectionName: 'drivers',
      id: driver.id,
      data: {
        'isOnline': false,
        'isAvailable': false,
        'lastSeen': FieldValue.serverTimestamp(),
      },
    );
  }

  Future<void> updateLocation({
    required AppUser driver,
    required LatLng location,
  }) async {
    await _storage.updateData(
      collectionName: 'drivers',
      id: driver.id,
      data: {
        'currentLocation': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
      },
    );
  }

  Stream<List<RideModel>> nearbyRideRequest() {
    return _storage.getStreamData(
      collectionName: 'rides',
      field: 'status',
      isEqualTo: Status.Requested.name,
      fromJson: RideModel.fromJson,
    );
  }

  Future<void> acceptRide({
    required AppUser driver,
    required String rideId,
  }) async {
    await _storage.updateData(
      collectionName: 'rides',
      id: rideId,
      data: {'status': Status.accepted.name, 'driverId': driver.id},
    );
    await _storage.updateData(
      collectionName: 'drivers',
      id: driver.id,
      data: {'isAvailable': false},
    );
  }

  Future<void> rejectRide({
    required String rideId,
    required AppUser driver,
  }) async {
    await _storage.updateData(
      collectionName: 'rides',
      id: rideId,
      data: {
        'rejectedDrivers': FieldValue.arrayUnion([driver.id]),
      },
    );
  }

  Future<void> startRide(String rideId) async {
    await _storage.updateData(
      collectionName: 'rides',
      id: rideId,
      data: {
        'status': Status.progress.name,
        'startedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  Future<void> completeRide(String rideId) async {
    await _storage.updateData(
      collectionName: 'rides',
      id: rideId,
      data: {
        'status': Status.completed.name,
        'completedAt': FieldValue.serverTimestamp(),
      },
    );
  }
}
