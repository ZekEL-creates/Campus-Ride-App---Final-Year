import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/features/map/data/map_exceptions.dart';
import 'package:ridesharingapp/features/map/data/map_repository.dart';
import 'package:ridesharingapp/features/map/domain/bloc/map_bloc.dart';
import 'package:ridesharingapp/features/map/domain/bloc/map_event.dart';
import 'package:ridesharingapp/features/map/domain/bloc/map_state.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  String? darkMapStyle;

  Future<void> loadMapStyle() async {
    darkMapStyle = await rootBundle.loadString('assets/json/dark_theme.json');
  }

  @override
  void initState() {
    super.initState();
    loadMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctxt) {
        final bloc = MapBloc(MapRepository());
        bloc.add(MapEventLoad());
        return bloc;
      },
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MapStateLoaded) {
            return GoogleMap(
              padding: EdgeInsets.only(top: 50, bottom: -20, right: 10),
              mapType: MapType.normal,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              style: darkMapStyle,
              onMapCreated: (controller) {},
              initialCameraPosition: CameraPosition(
                target: state.currentLocation,
                zoom: 18,
              ),
              markers: state.markers,
              cameraTargetBounds: CameraTargetBounds(
                LatLngBounds(
                  southwest: LatLng(6.6660, 3.6340),
                  northeast: LatLng(6.6735, 3.6410),
                ),
              ),
            );
          }
          if (state is MapStateError) {
            if (state.exception is LocationPermissionDeniedException) {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("Permission is not granted")],
                ),
              );
            }
            if (state.exception is LocationServiceDeniedException) {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("Location services is turned off")],
                ),
              );
            }
          }
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("What the hell is going on?")],
            ),
          );
        },
      ),
    );
  }
}

// return Scaffold(
//           body: SafeArea(
//             child: Column(
//               children: [
//                 Text("Hello ${rider!.name}, Would you like to log out?"),
//                 AppButton(
//                   buttonName: "Logout",
//                   onPressed: () async {
//                     final shouldLogout = await showLogoutDialog(
//                       context: context,
//                     );
//                     if (shouldLogout) {
//                       context.read<AuthBloc>().add(AuthEventLogOut());
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );


//  AppTextField(
//                   controller: nameController,
//                   topHint: 'Enter location name',
//                   hintText: "Location",
//                   icon: Icons.location_city,
//                 ),
//                 AppTextField(
//                   controller: latitudeController,
//                   topHint: 'Enter location Latitude',
//                   hintText: 'Latitude',
//                   icon: Icons.location_history,
//                 ),
//                 AppTextField(
//                   controller: longitudeController,
//                   topHint: 'Enter location Longitude',
//                   hintText: 'Longitude',
//                   icon: Icons.location_history,
//                 ),
//                 AppTextField(
//                   controller: typeController,
//                   topHint: 'Enter location type',
//                   hintText: 'Type',
//                   icon: Icons.merge_type_rounded,
//                 ),
//                 SizedBox(height: 20),
//                 AppButton(
//                   buttonName: 'Add to Firebase',
//                   onPressed: () async {
//                     try {
//                       final collection = collections.collection(
//                         'campus_locations',
//                       );
//                       final doc = collection.doc();

//                       final location = CampusLocationModel(
//                         id: doc.id,
//                         locationName: nameController.text,
//                         latitude: double.tryParse(latitudeController.text)!,
//                         longitude: double.tryParse(longitudeController.text)!,
//                         type: typeController.text,
//                       );

//                       await doc.set(location.toJson());

//                       nameController.clear();
//                       latitudeController.clear();
//                       longitudeController.clear();
//                       typeController.clear();
//                     } catch (e) {
//                       print(e);
//                     }
//                   },
//                 )