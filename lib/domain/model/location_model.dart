class LocationModel {
  int id;
  String name;
  double latitude;
  double longitude;
  double radius;

  LocationModel({required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude : json['longitude'],
      radius: json['radius'],
    );
  }
}
