import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';
import '../../Authentication/data/models/app_user.dart';

abstract class DriverEvent {
  const DriverEvent();
}

class DriverEventGoOnline extends DriverEvent {
  final AppUser driver;

  DriverEventGoOnline({required this.driver});
}

class DriverEventGoOffline extends DriverEvent {
  final AppUser driver;
  DriverEventGoOffline(this.driver);
}

class DriverEventUpdateLocations extends DriverEvent {
  final AppUser driver;
  final LatLng location;

  DriverEventUpdateLocations({required this.driver, required this.location});
}

class DriverEventListenForRides extends DriverEvent {
  const DriverEventListenForRides();
}

class DriverEventAcceptRide extends DriverEvent {
  final String rideId;
  final AppUser driver;

  DriverEventAcceptRide({required this.rideId, required this.driver});
}

class DriverEventRejectRide extends DriverEvent {
  final String rideId;
  final AppUser driver;

  DriverEventRejectRide({required this.rideId, required this.driver});
}

class DriverEventRidesUpdate extends DriverEvent {
  final List<RideModel> rides;
  DriverEventRidesUpdate(this.rides);
}

class DriverEventStartRide extends DriverEvent {
  final String rideId;

  DriverEventStartRide({required this.rideId});
}

class DriverEventCompleteRide extends DriverEvent {
  final String rideId;

  DriverEventCompleteRide({required this.rideId});
}
