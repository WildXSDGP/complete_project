
class LocationInfo {
  final String name;
  final double latitude;
  final double longitude;

  const LocationInfo({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  static const LocationInfo defaultLocation = LocationInfo(
    name: 'Yala National Park',
    latitude: 6.3728,
    longitude: 81.5152,
  );

  static const List<LocationInfo> predefinedLocations = [
    LocationInfo(name: 'Yala National Park',      latitude: 6.3728,  longitude: 81.5152),
    LocationInfo(name: 'Wilpattu National Park',  latitude: 8.4567,  longitude: 80.0144),
    LocationInfo(name: 'Udawalawe National Park', latitude: 6.4748,  longitude: 80.8973),
    LocationInfo(name: 'Minneriya National Park', latitude: 8.0355,  longitude: 80.8832),
    LocationInfo(name: 'Horton Plains NP',        latitude: 6.8017,  longitude: 80.8007),
    LocationInfo(name: 'Sinharaja Forest Reserve',latitude: 6.4017,  longitude: 80.4967),
  ];

  String get formattedCoordinates {
    String fmt(double val, List<String> dirs) {
      final dir = val >= 0 ? dirs[0] : dirs[1];
      final abs = val.abs();
      final deg = abs.floor();
      final minFull = (abs - deg) * 60;
      final min = minFull.floor();
      final sec = ((minFull - min) * 60).toStringAsFixed(0);
      return "$deg\u00b0${min}'$sec\"$dir";
    }
    return '${fmt(latitude, ['N','S'])} ${fmt(longitude, ['E','W'])}';
  }

  LocationInfo copyWith({String? name, double? latitude, double? longitude}) {
    return LocationInfo(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}