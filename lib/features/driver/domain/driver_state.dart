import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';

class DriverState {
  const DriverState();
}

class DriverStateDriver extends DriverState with EquatableMixin {
  final bool isLoading;
  final bool isOnline;
  final Exception? error;
  final List<RideModel>? rides;

  //tracking properties
  final RideModel? activeRide;
  final List<LatLng>? driverToPickupRoute;
  final List<LatLng>? driverToDestinationRoute;

  final bool isViewingTracking;

  bool get isTracking => activeRide != null;

  DriverStateDriver({
    required this.isLoading,
    required this.error,
    required this.isOnline,
    required this.rides,
    this.activeRide,
    this.driverToPickupRoute,
    this.driverToDestinationRoute,
    this.isViewingTracking = false,
  });

  DriverStateDriver copyWith({
    bool? isLoading,
    Exception? error,
    bool? isOnline,
    List<RideModel>? rides,
    RideModel? activeRide,
    bool clearActiveRide = false,
    bool clearError = false,
    final List<LatLng>? driverToPickupRoute,
    final List<LatLng>? driverToDestinationRoute,
    bool? isViewingTracking,
  }) {
    return DriverStateDriver(
      isLoading: isLoading ?? this.isLoading,
      isOnline: isOnline ?? this.isOnline,
      error: clearError ? null : (error ?? this.error),
      rides: rides ?? this.rides,
      activeRide: clearActiveRide ? null : (activeRide ?? this.activeRide),
      driverToPickupRoute: driverToPickupRoute ?? this.driverToPickupRoute,
      driverToDestinationRoute:
          driverToDestinationRoute ?? this.driverToDestinationRoute,
      isViewingTracking: isViewingTracking ?? this.isViewingTracking,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isOnline,
    error,
    rides,
    activeRide,
    isViewingTracking,
    driverToDestinationRoute,
    driverToPickupRoute,
  ];
}

// class DriverStateTracking extends DriverState with EquatableMixin {
//   final bool isLoading;
//   final Exception? error;

//   DriverStateTracking({
//     required this.ride,
//     required this.driverToPickupRoute,
//     required this.isLoading,
//     required this.error,
//     required this.driverToDestinationRoute,
//   });

//   DriverStateTracking copyWith({
//     bool? isLoading,
//     Exception? error,
//     RideModel? ride,
//     List<LatLng>? driverToPickupRoute,
//     List<LatLng>? driverToDestinationRoute,
//   }) {
//     return DriverStateTracking(
//       isLoading: isLoading ?? this.isLoading,
//       ride: ride ?? this.ride,
//       error: error,
//       driverToPickupRoute: driverToPickupRoute ?? this.driverToPickupRoute,
//       driverToDestinationRoute:
//           driverToDestinationRoute ?? this.driverToDestinationRoute,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     isLoading,
//     error,
//     driverToPickupRoute,
//     driverToDestinationRoute,
//     ride,
//   ];
// }

class DriverStateInitial extends DriverState {
  const DriverStateInitial();
}
