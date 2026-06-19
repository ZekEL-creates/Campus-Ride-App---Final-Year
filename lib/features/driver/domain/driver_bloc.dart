import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/core/constants/constants.dart';
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
      emit((state as DriverStateDriver).copyWith(isLoading: true, error: null));
      try {
        position = await mapRepository.getCurrentLocation();
        final location = LatLng(position!.latitude, position!.longitude);
        await repository.goOnline(driver: event.driver, location: location);
        add(DriverEventListenForRides());
        emit(
          (state as DriverStateDriver).copyWith(
            isLoading: false,
            isOnline: true,
          ),
        );
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventGoOffline>((event, emit) async {
      emit((state as DriverStateDriver).copyWith(isLoading: true, error: null));
      try {
        await repository.goOffline(driver: event.driver);
        emit(
          (state as DriverStateDriver).copyWith(
            isLoading: false,
            isOnline: false,
          ),
        );
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventRidesUpdate>((event, emit) {
      final current = state as DriverStateDriver;
      emit(current.copyWith(rides: event.rides, error: null));
    });

    on<DriverEventUpdateLocations>((event, emit) async {
      try {
        await repository.updateLocation(
          driver: event.driver,
          location: event.location,
        );
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(error: e));
      }
    });

    on<DriverEventAcceptRide>((event, emit) async {
      emit((state as DriverStateDriver).copyWith(isLoading: true, error: null));
      try {
        await repository.acceptRide(driver: event.driver, rideId: event.rideId);
        emit((state as DriverStateDriver).copyWith(isLoading: false));
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventRejectRide>((event, emit) async {
      emit((state as DriverStateDriver).copyWith(isLoading: true, error: null));
      try {
        await repository.rejectRide(rideId: event.rideId, driver: event.driver);
        emit((state as DriverStateDriver).copyWith(isLoading: false));
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(error: e, isLoading: false));
      }
    });

    on<DriverEventStartRide>((event, emit) async {
      emit((state as DriverStateDriver).copyWith(isLoading: true, error: null));
      try {
        await repository.startRide(event.rideId);
        emit((state as DriverStateDriver).copyWith(isLoading: false));
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventCompleteRide>((event, emit) async {
      emit((state as DriverStateDriver).copyWith(isLoading: true, error: null));
      try {
        await repository.completeRide(event.rideId);
        emit((state as DriverStateDriver).copyWith(isLoading: false));
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(isLoading: false, error: e));
      }
    });

    on<DriverEventListenForRides>((event, emit) {
      try {
        _ridesSubsciption?.cancel();
        _ridesSubsciption = repository.nearbyRideRequest().listen((rides) {
          add(DriverEventRidesUpdate(rides));
        });
      } on Exception catch (e) {
        emit((state as DriverStateDriver).copyWith(error: e));
      }
    });
  }
  @override
  Future<void> close() async {
    await _ridesSubsciption?.cancel();
    return super.close();
  }
}
