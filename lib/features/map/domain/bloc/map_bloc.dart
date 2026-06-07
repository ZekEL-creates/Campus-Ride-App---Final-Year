import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/features/map/data/map_repository.dart';
import 'package:ridesharingapp/features/map/domain/bloc/map_event.dart';
import 'package:ridesharingapp/features/map/domain/bloc/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository repository;
  MapBloc(this.repository) : super(MapStateInitial()) {
    on<MapEventLoad>((event, emit) async {
      emit(MapStateLoading());
      try {
        final position = await repository.getCurrentLocation();
        print("Postion: $position");
        final locations = await repository.getCampusLocations();
        Set<Marker> markers = {};

        for (var doc in locations.docs) {
          print(doc.data());
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
        print("Markers: $markers");
        emit(
          MapStateLoaded(
            currentLocation: LatLng(position.latitude, position.longitude),
            markers: markers,
          ),
        );
      } on Exception catch (e) {
        emit(MapStateError(exception: e));
      }
    });
  }
}
