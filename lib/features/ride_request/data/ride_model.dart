class RideModel {
  final String id;
  final String riderId;
  final String? driverId;
  final double pickUpLatitude;
  final double pickUpLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final String status;
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
    requestedAt: json['requested_at'],
    driverLatitude: json['driver_latitude'],
    driverLongitude: json['driver_longitude'],
  );

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
    };
  }
}
