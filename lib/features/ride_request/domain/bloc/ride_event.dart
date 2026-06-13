import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';

class RideEvent {
  const RideEvent();
}

class RideEventRequestRide extends RideEvent {
  RideModel ride;
  RideEventRequestRide(this.ride);
}

class RideEventBack extends RideEvent {}

class RideEventRideRequest extends RideEvent {}

class RideEventUpdateInfo extends RideEvent {
  final String id;
  final Map<String, dynamic> data;

  RideEventUpdateInfo({required this.id, required this.data});
}
