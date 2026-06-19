import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/core/constants/constants.dart';
import 'package:ridesharingapp/features/map/data/map_repository.dart';
import 'package:ridesharingapp/features/map/domain/bloc/map_event.dart';
import 'package:ridesharingapp/features/map/domain/bloc/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository repository;
  MapBloc(this.repository) : super(MapStateInitial()) {
    on<MapEventLoad>((event, emit) async {
      emit(MapStateLoading());
      try {
        Set<Marker> markers = {};

        if (locations == null || position == null) {
          emit(MapStateError(exception: Exception("An Error Occured")));
        }

        for (var doc in locations!.docs) {
          markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(
                (doc['latitude'] as num).toDouble(),
                (doc['longitude'] as num).toDouble(),
              ),
              infoWindow: InfoWindow(title: doc['location_name']),
            ),
          );
        }
        emit(
          MapStateLoaded(
            currentLocation: LatLng(position!.latitude, position!.longitude),
            markers: markers,
          ),
        );
      } on Exception catch (e) {
        emit(MapStateError(exception: e));
      }
    });
  }
}
