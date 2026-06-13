import 'package:bloc/bloc.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/features/map/data/models/campus_location.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_repository.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_event.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_state.dart';
import 'package:ridesharingapp/services/firebase_storage_service.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  final RideRepository repository;
  RideBloc(this.repository) : super(RideStateInitial()) {
    on<RideEventRequestRide>((event, emit) async {
      try {
        emit(RideStateLoading());
        repository.createRide(event.ride);
        emit(RideStateRequested());
      } on Exception catch (exception) {
        emit(RideStateError(exception));
      }
    });

    on<RideEventBack>((event, emit) {
      emit(RideStateInitial());
    });

    on<RideEventRideRequest>((event, emit) async {
      final FirebaseStorageService storage = FirebaseStorageService();
      emit(RideStateLoading());
      // final locationSnapshot = await FirebaseFirestore.instance
      //     .collection('campus_locations')
      //     .get();
      final campusLocations = await storage.getAllData(
        collectionName: 'campus_locations',
        fromJson: CampusLocationModel.fromJson,
      );

      // locationSnapshot.docs
      //     .map((doc) => CampusLocationModel.fromJson(doc.data()))
      //     .toList();
      emit(RideStateSelectLocation(campusLocations));
    });

    on<RideEventUpdateInfo>((event, emit) async {
      try {
        emit(RideStateLoading());
        final FirebaseStorageService storage = FirebaseStorageService();
        await storage.updateNote(
          collectionName: 'users',
          id: event.id,
          data: event.data,
        );
        await storage.getData(
          collectionName: 'users',
          id: event.id,
          fromJson: AppUser.fromJson,
        );
        emit(RideStateInitial());
      } on Exception catch (exception) {
        emit(RideStateError(exception));
      }
    });
  }
}
