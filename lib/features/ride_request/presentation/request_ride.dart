import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/dialogs/error_dialog.dart';
import 'package:ridesharingapp/core/enum/status.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_bloc.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_event.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_state.dart';
import 'package:uuid/uuid.dart';

class RequestRide extends StatefulWidget {
  final RideStateSelectLocation state;
  const RequestRide({super.key, required this.state});

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
  late final TextEditingController toController;
  late final TextEditingController fromController;
  String toText = '';
  String fromText = '';
  final fromFocusNode = FocusNode();
  final toFocusNode = FocusNode();
  RideModel? model;
  double? fromLatitude;
  double? fromLongitude;
  double? toLatitude;
  double? toLongitude;
  String? pickUpName;
  String? destinationName;
  final uuid = Uuid();
  late final String riderId;
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthStateLoggedInAsRider) {
      riderId = authState.rider.id;
    }

    toController = TextEditingController();
    fromController = TextEditingController();
    _setUpToTextControllerListener();
    _setUpFromTextControllerListener();
  }

  void _toTextControllerListener() {
    toText = toController.text;
    setState(() {});
  }

  void _setUpToTextControllerListener() {
    toController.removeListener(_toTextControllerListener);
    toController.addListener(_toTextControllerListener);
  }

  void _fromTextControllerListener() {
    fromText = fromController.text;
    setState(() {});
  }

  void _setUpFromTextControllerListener() {
    fromController.removeListener(_fromTextControllerListener);
    fromController.addListener(_fromTextControllerListener);
  }

  @override
  void dispose() {
    toController.dispose();
    fromController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchText = fromFocusNode.hasFocus ? fromText : toText;
    final filteredLocations = widget.state.locations.where((location) {
      return location.locationName.toLowerCase().contains(
        searchText.toLowerCase(),
      );
    }).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<RideBloc>().add(RideEventBack());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: fromController,
                focusNode: fromFocusNode,
                decoration: InputDecoration(
                  hintText: 'From: Within Caleb Campus',
                  hintStyle: TextStyle(color: Colors.deepOrange),
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.lightBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.backgroundColor),
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: toController,
                focusNode: toFocusNode,
                decoration: InputDecoration(
                  hintText: 'To: Within Caleb Campus',
                  hintStyle: TextStyle(color: Colors.green),
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.lightBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.backgroundColor),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if (searchText == fromText) {
                        fromController.text =
                            filteredLocations[index].locationName;
                        fromFocusNode.unfocus();
                        fromLatitude = filteredLocations[index].latitude;
                        fromLongitude = filteredLocations[index].longitude;
                        if (fromLatitude != null && fromLongitude != null) {
                          pickUpName = filteredLocations[index].locationName;
                        }
                      } else if (searchText == toText) {
                        toController.text =
                            filteredLocations[index].locationName;
                        toFocusNode.unfocus();
                        toLatitude = filteredLocations[index].latitude;
                        toLongitude = filteredLocations[index].longitude;
                        if (toLatitude != null && toLongitude != null) {
                          destinationName =
                              filteredLocations[index].locationName;
                        }
                      }
                    },
                    leading: Icon(Icons.location_on, color: Colors.red),
                    title: Text(
                      filteredLocations[index].locationName,
                      style: TextStyle(
                        color: AppColors.lightDarktextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(filteredLocations[index].type),
                  );
                },
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButton(
                  buttonName: 'Request Ride',
                  onPressed: () {
                    if (fromLatitude == null ||
                        fromLongitude == null ||
                        toLatitude == null ||
                        toLongitude == null ||
                        pickUpName == null ||
                        destinationName == null) {
                      showErrorDialog(
                        content: 'Please Select desired Locations',
                        context: context,
                      );
                      return;
                    }

                    model = RideModel(
                      id: uuid.v4(),
                      riderId: riderId,
                      pickUpLatitude: fromLatitude!,
                      pickUpLongitude: fromLongitude!,
                      destinationLatitude: toLatitude!,
                      destinationLongitude: toLongitude!,
                      status: Status.Requested.name,
                      requestedAt: DateTime.now(),
                      driverId: null,
                      driverLatitude: null,
                      driverLongitude: null,
                      pickUpName: pickUpName!,
                      destinationName: destinationName!,
                      rejectedDrivers: [],
                    );

                    context.read<RideBloc>().add(RideEventRequestRide(model!));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
