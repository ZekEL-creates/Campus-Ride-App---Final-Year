import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/features/map/data/models/campus_location.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';

class RideState {
  const RideState();
}

class RideStateInitial extends RideState {
  const RideStateInitial();
}

class RideStateRequested extends RideState {
  final RideModel ride;
  final List<LatLng> route;

  RideStateRequested({required this.ride, required this.route});
}

class RideStateLoading extends RideState {
  const RideStateLoading();
}

class RideStateError extends RideState {
  final Exception exception;
  RideStateError(this.exception);
}

class RideStateUpdateSuccess extends RideState {
  const RideStateUpdateSuccess();
}

class RideStateSelectLocation extends RideState {
  List<CampusLocationModel> locations;
  RideStateSelectLocation(this.locations);
}
