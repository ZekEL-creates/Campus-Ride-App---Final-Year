import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/core/constants/constants.dart';
import 'package:ridesharingapp/core/enum/status.dart';
import 'package:ridesharingapp/features/driver/data/driver_repository.dart';
import 'package:ridesharingapp/features/driver/domain/driver_event.dart';
import 'package:ridesharingapp/features/driver/domain/driver_state.dart';
import 'package:ridesharingapp/features/map/data/map_repository.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final DriverRepository repository;
  final MapRepository mapRepository;
  StreamSubscription? _ridesSubsciption;
  DriverBloc(this.repository, this.mapRepository)
    : super(
        DriverStateDriver(
          isLoading: false,
          error: null,
          rides: [],
          isOnline: false,
        ),
      ) {
    on<DriverEventGoOnline>((event, emit) async {
      emit(
        (state as DriverStateDriver).copyWith(
          isLoading: true,
          clearError: true,
        ),
      );
      try {
        position = await mapRepository.getCurrentLocation();
        final location = LatLng(position!.latitude, position!.longitude);
        await repository.goOnline(driver: event.driver, location: location);
        add(DriverEventListenForRides());
        print(
          'You are now online, Rides requested are${(state as DriverStateDriver).rides}',
        );
        emit(
          (state as DriverStateDriver).copyWith(
            isLoading: false,
            isOnline: true,
          ),
        );
      } on Exception catch (e) {
        print(e.runtimeType.toString());
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventGoOffline>((event, emit) async {
      emit(
        (state as DriverStateDriver).copyWith(
          isLoading: true,
          clearError: true,
        ),
      );
      try {
        await repository.goOffline(driver: event.driver);
        emit(
          (state as DriverStateDriver).copyWith(
            isLoading: false,
            isOnline: false,
          ),
        );
      } on Exception catch (e) {
        print(e.runtimeType.toString());
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventRidesUpdate>((event, emit) {
      print('Rides Update: ${event.rides.length}');
      final current = state as DriverStateDriver;
      emit(current.copyWith(rides: event.rides, clearError: true));
    });

    on<DriverEventUpdateLocations>((event, emit) async {
      try {
        await repository.updateLocation(
          driver: event.driver,
          location: event.location,
        );
      } on Exception catch (e) {
        print(e.runtimeType.toString());
        emit((state as DriverStateDriver).copyWith(error: e));
      }
    });

    on<DriverEventAcceptRide>((event, emit) async {
      emit(
        (state as DriverStateDriver).copyWith(
          isLoading: true,
          clearError: true,
        ),
      );
      try {
        await repository.acceptRide(driver: event.driver, rideId: event.rideId);
        emit((state as DriverStateDriver).copyWith(isLoading: false));
      } on Exception catch (e) {
        print(e.runtimeType.toString());
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventRejectRide>((event, emit) async {
      emit(
        (state as DriverStateDriver).copyWith(
          isLoading: true,
          clearError: true,
        ),
      );
      try {
        await repository.rejectRide(rideId: event.rideId, driver: event.driver);
        emit((state as DriverStateDriver).copyWith(isLoading: false));
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(error: e, isLoading: false));
      }
    });

    on<DriverEventStartRide>((event, emit) async {
      emit(
        (state as DriverStateDriver).copyWith(
          isLoading: true,
          clearError: true,
        ),
      );
      try {
        await repository.startRide(event.rideId);
        final current = state as DriverStateDriver;
        final updatedRide = current.activeRide!.copywith(
          status: Status.started.name,
        );
        emit(current.copyWith(isLoading: false, activeRide: updatedRide));
      } on Exception catch (e) {
        print(e.runtimeType.toString());
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventCompleteRide>((event, emit) async {
      emit(
        (state as DriverStateDriver).copyWith(
          isLoading: true,
          clearError: true,
        ),
      );
      try {
        await repository.completeRide(event.rideId);
        emit(
          (state as DriverStateDriver).copyWith(
            isLoading: false,
            driverToDestinationRoute: [],
            driverToPickupRoute: [],
            isViewingTracking: false,
            clearActiveRide: true,
          ),
        );
      } on Exception catch (e) {
        print(e.runtimeType.toString());
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventListenForRides>((event, emit) {
      try {
        _ridesSubsciption?.cancel();
        _ridesSubsciption = repository.nearbyRideRequest().listen(
          (rides) {
            print('STREAMED DATA: ${rides.length} RIDES');
            for (final ride in rides) {
              print('RIDE ID ${ride.id} HAS A ${ride.status} STATUS');
            }
            add(DriverEventRidesUpdate(rides));
          },
          // onError: (e) {
          //   emit((state as DriverStateDriver).copyWith(error: e));
          // },
        );
      } on Exception catch (e) {
        print(e.runtimeType.toString());
        emit((state as DriverStateDriver).copyWith(error: e));
      }
    });

    on<DriverEventTrackRide>((event, emit) async {
      emit(
        (state as DriverStateDriver).copyWith(
          activeRide: event.ride,
          isLoading: true,
          isViewingTracking: true,
          clearError: true,
        ),
      );
      try {
        print('ACTIVE RIDE: ${event.ride}');
        final getDriverToPickUpRoute = await mapRepository.getRoute(
          startLat: event.ride.driverLatitude!,
          startLng: event.ride.driverLongitude!,
          endLat: event.ride.pickUpLatitude,
          endLng: event.ride.pickUpLongitude,
        );
        final pickUpToDestinationRoute = await mapRepository.getRoute(
          startLat: event.ride.pickUpLatitude,
          startLng: event.ride.pickUpLongitude,
          endLat: event.ride.destinationLatitude,
          endLng: event.ride.destinationLongitude,
        );
        print('DRIVER TO PICKUP ROUE: $getDriverToPickUpRoute');
        print('DRIVER TO PICKUP ROUE: $pickUpToDestinationRoute');
        emit(
          (state as DriverStateDriver).copyWith(
            driverToPickupRoute: getDriverToPickUpRoute,
            driverToDestinationRoute: pickUpToDestinationRoute,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        print(e.runtimeType.toString());
        emit(
          (state as DriverStateDriver).copyWith(
            isLoading: false,
            error: e,
            isViewingTracking: false,
            clearActiveRide: true,
          ),
        );
      }
    });

    on<DriverEventCloseTracking>((event, emit) {
      emit((state as DriverStateDriver).copyWith(isViewingTracking: false));
    });

    on<DriverEventResumeTracking>((event, emit) {
      emit((state as DriverStateDriver).copyWith(isViewingTracking: true));
    });
  }
  @override
  Future<void> close() async {
    await _ridesSubsciption?.cancel();
    return super.close();
  }
}
