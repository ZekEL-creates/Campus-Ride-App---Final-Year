import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';
import 'package:ridesharingapp/services/firebase_storage_service.dart';

class RideRepository {
  //final rideCollection = FirebaseFirestore.instance.collection('rides');
  final _storage = FirebaseStorageService();

  Future<void> createRide(RideModel ride) async {
    await _storage.create(
      collectionName: 'rides',
      id: ride.id,
      data: ride.toJson(),
    );
    //rideCollection.doc(ride.id).set(ride.toJson());
  }
}
