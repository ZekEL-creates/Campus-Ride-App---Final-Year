import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';

class RideRepository {
  final rideCollection = FirebaseFirestore.instance.collection('rides');

  Future<void> createRide(RideModel ride) async {
    await rideCollection.doc(ride.id).set(ride.toJson());
  }
}
