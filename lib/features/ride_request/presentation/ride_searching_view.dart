import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/widgets/custom_map.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';

class RideSearchingView extends StatefulWidget {
  const RideSearchingView({
    super.key,
    required this.ride,
    required this.routePoints,
  });
  final RideModel ride;
  final List<LatLng> routePoints;

  @override
  State<RideSearchingView> createState() => _RideSearchingViewState();
}

class _RideSearchingViewState extends State<RideSearchingView> {
  final sheetController = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: widget.routePoints,
        width: 6,
        color: Colors.blue,
      ),
    };
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(
          widget.ride.pickUpLatitude,
          widget.ride.pickUpLongitude,
        ),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          widget.ride.destinationLatitude,
          widget.ride.destinationLongitude,
        ),
      ),
    };
    void fitRoute({
      required GoogleMapController controller,
      required RideModel ride,
    }) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          min(ride.pickUpLatitude, ride.destinationLatitude),
          min(ride.pickUpLongitude, ride.destinationLongitude),
        ),
        northeast: LatLng(
          max(ride.pickUpLatitude, ride.destinationLatitude),
          max(ride.pickUpLongitude, ride.destinationLongitude),
        ),
      );
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomMap(
            target: LatLng(
              widget.ride.pickUpLatitude,
              widget.ride.pickUpLongitude,
            ),
            markers: markers,
            zoom: 10,
            polyline: polylines,
            onMapCreated: (controller) {
              fitRoute(controller: controller, ride: widget.ride);
            },
          ),
          DraggableScrollableSheet(
            controller: sheetController,
            initialChildSize: 0.25,
            minChildSize: 0.15,
            maxChildSize: 0.8,
            expand: true,
            snap: true,
            snapSizes: [0.25, 0.5, 0.8],
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: AppColors.lightBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Drag Handle
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: widget.routePoints.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const Icon(
                            Icons.local_taxi,
                            color: AppColors.backgroundColor,
                          ),
                          title: Text(widget.ride.status),
                          subtitle: Text('The driver diaplays here'),
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
    );
  }
}
