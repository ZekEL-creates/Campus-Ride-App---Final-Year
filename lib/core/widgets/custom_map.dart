import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMap extends StatelessWidget {
  const CustomMap({
    super.key,
    required this.target,
    required this.markers,
    this.zoom,
    this.polyline,
    this.onMapCreated,
  });

  final LatLng target;
  final Set<Marker> markers;
  final double? zoom;
  final Set<Polyline>? polyline;
  final Function(GoogleMapController)? onMapCreated;

  String? get darkMapStyle => null;
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: EdgeInsets.only(top: 50, bottom: -20, right: 10),
      mapType: MapType.normal,
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      style: darkMapStyle,
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(target: target, zoom: zoom ?? 18),
      markers: markers,
      polylines: polyline ?? const <Polyline>{},
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          southwest: LatLng(6.6660, 3.6340),
          northeast: LatLng(6.6735, 3.6410),
        ),
      ),
    );
  }
}
