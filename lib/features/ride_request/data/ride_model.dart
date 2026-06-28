import 'package:cloud_firestore/cloud_firestore.dart';

class RideModel {
  final String id;
  final String riderId;

  final String? driverId;
  final String pickUpName;

  final double pickUpLatitude;
  final double pickUpLongitude;

  final String destinationName;
  final double destinationLatitude;

  final double destinationLongitude;
  final String status;

  final List<String>? rejectedDrivers;
  final DateTime requestedAt;

  final double? driverLatitude;
  final double? driverLongitude;

  RideModel({
    required this.id,
    required this.riderId,
    this.driverId,
    required this.pickUpLatitude,
    required this.pickUpLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.status,
    required this.requestedAt,
    this.driverLatitude,
    this.driverLongitude,
    required this.pickUpName,
    required this.destinationName,
    required this.rejectedDrivers,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
    id: json['id'],
    riderId: json['riderId'],
    driverId: json['driverId'],
    pickUpLatitude: json['pickUpLatitude'],
    pickUpLongitude: json['pickUpLongitude'],
    destinationLatitude: json['destinationLatitude'],
    destinationLongitude: json['destinationLongitude'],
    status: json['status'],
    requestedAt: (json['requested_at'] as Timestamp).toDate(),
    driverLatitude: json['driver_latitude'],
    driverLongitude: json['driver_longitude'],
    pickUpName: json['pickUpName'],
    destinationName: json['destinationName'],
    rejectedDrivers: (json['rejectedDrivers'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
  );

  RideModel copywith({
    String? status,
    String? riderId,
    String? driverId,
    String? pickUpName,

    double? pickUpLatitude,
    double? pickUpLongitude,
    String? destinationName,
    double? destinationLatitude,
    double? destinationLongitude,

    List<String>? rejectedDrivers,
    DateTime? requestedAt,
    double? driverLatitude,
    double? driverLongitude,
  }) {
    return RideModel(
      id: id,
      riderId: riderId ?? this.riderId,
      pickUpLatitude: pickUpLatitude ?? this.pickUpLatitude,
      pickUpLongitude: pickUpLongitude ?? this.pickUpLongitude,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
      driverLatitude: driverLatitude ?? this.driverLatitude,
      driverLongitude: driverLongitude ?? this.driverLongitude,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      pickUpName: pickUpName ?? this.pickUpName,
      destinationName: destinationName ?? this.destinationName,
      rejectedDrivers: rejectedDrivers ?? this.rejectedDrivers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'riderId': riderId,
      'driverId': driverId,
      'pickUpLatitude': pickUpLatitude,
      'pickUpLongitude': pickUpLongitude,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'status': status,
      'requested_at': requestedAt,
      'driver_latitude': driverLatitude,
      'driver_longitude': driverLongitude,
      'pickUpName': pickUpName,
      'destinationName': destinationName,
      'rejectedDrivers': rejectedDrivers,
    };
  }
}
