import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/enum/status.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/core/widgets/custom_map.dart';
import 'package:ridesharingapp/core/widgets/error_view.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';
import 'package:ridesharingapp/features/driver/domain/driver_bloc.dart';
import 'package:ridesharingapp/features/driver/domain/driver_event.dart';
import 'package:ridesharingapp/features/driver/domain/driver_state.dart';

class RideTrackingPage extends StatefulWidget {
  final VoidCallback onBack;
  const RideTrackingPage({super.key, required this.onBack});

  @override
  State<RideTrackingPage> createState() => _RideTrackingPageState();
}

class _RideTrackingPageState extends State<RideTrackingPage> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _locationSubscription;
  LatLng? _driverPosition;
  AppUser? driver;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthStateLoggedInAsDriver) {
      driver = authState.driver;
    }

    _startLocationStream();
  }

  //track driver movement
  void _startLocationStream() {
    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((postion) async {
          final newPos = LatLng(postion.latitude, postion.longitude);
          setState(() {
            _driverPosition = newPos;
          });
          _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));

          final state = context.read<DriverBloc>().state as DriverStateDriver;
          if (state.activeRide != null && state.isOnline) {
            context.read<DriverBloc>().add(
              DriverEventUpdateLocations(driver: driver!, location: newPos),
            );
          }
        });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Set<Polyline> _buildPolylines(DriverStateDriver state) {
    final isRideStarted = state.activeRide?.status == Status.started.name;

    print(isRideStarted);

    return {
      //rider to pick up line if ride has not started
      if (!isRideStarted &&
          state.driverToPickupRoute != null &&
          state.driverToPickupRoute!.isNotEmpty)
        Polyline(
          polylineId: const PolylineId('driver_pickUp'),
          points: state.driverToPickupRoute!,
          color: Colors.blue,
          width: 5,
        ),

      //ride to destination always shown
      if (isRideStarted &&
          state.driverToDestinationRoute != null &&
          state.driverToDestinationRoute!.isNotEmpty)
        Polyline(
          polylineId: PolylineId('pickUp_destination'),
          points: state.driverToDestinationRoute!,
          color: Colors.green,
          width: 5,
        ),
    };
  }

  LatLng _initialCameraTarger(DriverStateDriver state) {
    final ride = state.activeRide!;
    return _driverPosition ?? LatLng(ride.pickUpLatitude, ride.pickUpLongitude);
  }

  Set<Marker> _buildMarkers(DriverStateDriver state) {
    final ride = state.activeRide!;
    final isRideStarted = ride.status == Status.started.name;

    return {
      if (_driverPosition != null)
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'You'),
        ),
      if (!isRideStarted)
        Marker(
          markerId: const MarkerId('pickUp'),
          position: LatLng(ride.pickUpLatitude, ride.pickUpLongitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(title: 'Pickup: ${ride.pickUpName}'),
        ),

      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(ride.destinationLatitude, ride.destinationLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Destination: ${ride.destinationName}'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverBloc, DriverState>(
      builder: (context, state) {
        final driverState = state as DriverStateDriver;
        final ride = driverState.activeRide;

        if (ride == null) {
          return const Scaffold(body: Center(child: Text('No active Rides')));
        }

        final isRideStarted = ride.status == Status.started.name;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) widget.onBack();
          },
          child: Scaffold(
            body: Stack(
              children: [
                CustomMap(
                  target: _initialCameraTarger(driverState),
                  markers: _buildMarkers(driverState),
                  polyline: _buildPolylines(driverState),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (_driverPosition != null) {
                      controller.animateCamera(
                        CameraUpdate.newLatLng(_driverPosition!),
                      );
                    }
                  },
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  zoom: 15,
                ),
                // Inside the Stack in RideTrackingPage, replace the error Positioned with:
                if (driverState.error != null)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
                      child: ErrorView(
                        message: driverState.error.toString(),
                        retryLabel: isRideStarted
                            ? 'Retry Complete Ride'
                            : 'Retry Start Ride',
                        onRetry: () {
                          final bloc = context.read<DriverBloc>();
                          if (isRideStarted) {
                            bloc.add(DriverEventCompleteRide(rideId: ride.id));
                          } else {
                            bloc.add(DriverEventStartRide(rideId: ride.id));
                          }
                        },
                      ),
                    ),
                  ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: SafeArea(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: widget.onBack,
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isRideStarted
                                ? AppColors.greenColor
                                : AppColors.backgroundColor,
                          ),
                          color: AppColors.lightBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: isRideStarted
                                  ? AppColors.greenColor
                                  : AppColors.backgroundColor,
                              child: SizedBox(),
                            ),
                            SizedBox(width: 5),
                            Text(
                              isRideStarted
                                  ? 'Ride in progress'
                                  : 'Heading to pickup',
                              style: TextStyle(
                                color: isRideStarted
                                    ? AppColors.greenColor
                                    : AppColors.backgroundColor,
                                fontWeight: .w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
                    decoration: const BoxDecoration(
                      color: AppColors.lightBackgroundColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRideStarted
                              ? 'Dropping Off Rider'
                              : 'Heading to PickUp',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.lightDarktextColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          isRideStarted
                              ? ride.destinationName
                              : ride.pickUpName,
                          style: TextStyle(fontSize: 20, fontWeight: .w700),
                        ),
                        SizedBox(height: 4),
                        Text(
                          isRideStarted
                              ? 'Destination: ${ride.destinationName}'
                              : 'Pickup: ${ride.pickUpName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.lightDarktextColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: AppButton(
                            buttonName: '',
                            backgroundColor: isRideStarted
                                ? AppColors.greenColor
                                : AppColors.backgroundColor,

                            onPressed:
                                driverState.isLoading ||
                                    (!isRideStarted &&
                                        (driverState.driverToPickupRoute ==
                                                null ||
                                            driverState
                                                .driverToPickupRoute!
                                                .isEmpty))
                                ? null
                                : () {
                                    print(
                                      'DRIVER TO PICK UP: ${driverState.driverToPickupRoute}',
                                    );
                                    print('Started Ride: $isRideStarted');
                                    final bloc = context.read<DriverBloc>();
                                    if (isRideStarted) {
                                      bloc.add(
                                        DriverEventCompleteRide(
                                          rideId: ride.id,
                                        ),
                                      );
                                    } else {
                                      bloc.add(
                                        DriverEventStartRide(rideId: ride.id),
                                      );
                                    }
                                  },
                            child: driverState.isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isRideStarted
                                        ? 'Complete Ride'
                                        : 'Start Ride',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: .w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
