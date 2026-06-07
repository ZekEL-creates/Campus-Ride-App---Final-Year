import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {
  const MapState();
}

class MapStateInitial extends MapState {
  const MapStateInitial();
}

class MapStateLoading extends MapState {
  const MapStateLoading();
}

class MapStateLoaded extends MapState {
  final LatLng currentLocation;
  final Set<Marker> markers;

  MapStateLoaded({required this.currentLocation, required this.markers});
}

class MapStateError extends MapState {
  final Exception exception;

  MapStateError({required this.exception});
}
