import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email, "role": role};
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
  );
}

class Driver extends AppUser {
  final double? driverLatitude;
  final double? driverLongitude;
  final bool isAvailable;
  final bool isOnline;

  Driver({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    this.driverLatitude,
    this.driverLongitude,
    required this.isAvailable,
    required this.isOnline,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "isOnline": isOnline,
      "isAvailable": isAvailable,
      "currentLocation": {
        "latitude": driverLatitude,
        "longitude": driverLongitude,
      },
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    driverLatitude: json['currentLocation']['latitude'],
    driverLongitude: json['currentLocation']['longitude'],
    isAvailable: json['isAvailable'],
    isOnline: json['isOnline'],
  );
}
