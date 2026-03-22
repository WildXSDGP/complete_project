class LocationInfo {
  final String parkName;
  final String block;
  final double latitude;
  final double longitude;

  const LocationInfo({
    required this.parkName,
    required this.block,
    required this.latitude,
    required this.longitude,
  });

  String get latStr {
    final deg = latitude.abs().floor();
    final min = ((latitude.abs() - deg) * 60).toStringAsFixed(1);
    return "$deg°$min'${latitude >= 0 ? 'N' : 'S'}";
  }

  String get lngStr {
    final deg = longitude.abs().floor();
    final min = ((longitude.abs() - deg) * 60).toStringAsFixed(1);
    return "$deg°$min'${longitude >= 0 ? 'E' : 'W'}";
  }

  String get coordinates => '$latStr $lngStr';
  String get fullLocation => parkName.isNotEmpty ? '$parkName, $block' : block;

  LocationInfo copyWith({
    String? parkName,
    String? block,
    double? latitude,
    double? longitude,
  }) {
    return LocationInfo(
      parkName: parkName ?? this.parkName,
      block: block ?? this.block,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

// Fallback default (Yala)
const defaultLocation = LocationInfo(
  parkName: 'Yala National Park',
  block: 'Block 1',
  latitude: 6.3697,
  longitude: 81.5186,
);
