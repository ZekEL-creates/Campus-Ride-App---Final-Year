class CampusLocationModel {
  final String id;
  final String locationName;
  final double latitude;
  final double longitude;
  final String type;

  CampusLocationModel({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'location_name': locationName,
    'latitude': latitude,
    'longitude': longitude,
    'type': type,
  };

  factory CampusLocationModel.fromJson(Map<String, dynamic> json) =>
      CampusLocationModel(
        id: json['id'],
        locationName: json['location_name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        type: json['type'],
      );
}
