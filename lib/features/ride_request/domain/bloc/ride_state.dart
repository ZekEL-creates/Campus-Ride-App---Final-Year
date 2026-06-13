import 'package:ridesharingapp/features/map/data/models/campus_location.dart';

class RideState {
  const RideState();
}

class RideStateInitial extends RideState {}

class RideStateRequested extends RideState {}

class RideStateLoading extends RideState {}

class RideStateError extends RideState {
  final Exception exception;
  RideStateError(this.exception);
}

class RideStateSelectLocation extends RideState {
  List<CampusLocationModel> locations;
  RideStateSelectLocation(this.locations);
}
