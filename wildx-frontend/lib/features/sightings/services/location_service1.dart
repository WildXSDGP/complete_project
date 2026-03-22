import 'package:geolocator/geolocator.dart';
import '../models/location_info1.dart';

class LocationService {
  /// Returns the device's real GPS coordinates.
  /// Handles permission requests automatically.
  Future<LocationInfo> getCurrentLocation() async {
    // 1. Check if location services are enabled on the device
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Location services are disabled. Please enable GPS in settings.',
      );
    }

    // 2. Check / request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException('Location permission was denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission is permanently denied. '
        'Please enable it in app settings.',
      );
    }

    // 3. Fetch position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4. Try to match a known park by proximity (within ~30 km)
    final nearby = _nearestPark(position.latitude, position.longitude);

    return LocationInfo(
      name: nearby?.name ?? 'Current Location',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// Nearest predefined park within 30 km, or null.
  LocationInfo? _nearestPark(double lat, double lon) {
    const maxMeters = 30000.0;
    LocationInfo? best;
    double bestDist = double.infinity;

    for (final park in LocationInfo.predefinedLocations) {
      final d = Geolocator.distanceBetween(lat, lon, park.latitude, park.longitude);
      if (d < bestDist && d < maxMeters) {
        bestDist = d;
        best = park;
      }
    }
    return best;
  }

  List<LocationInfo> searchLocations(String query) {
    if (query.trim().isEmpty) return LocationInfo.predefinedLocations;
    final q = query.toLowerCase();
    return LocationInfo.predefinedLocations
        .where((l) => l.name.toLowerCase().contains(q))
        .toList();
  }
}

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);
  @override
  String toString() => message;
}