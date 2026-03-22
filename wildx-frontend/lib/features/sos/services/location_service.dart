import 'package:geolocator/geolocator.dart';
import '../models/location_info.dart';

enum LocationStatus { loading, success, permissionDenied, unavailable }

class LocationResult {
  final LocationInfo? location;
  final LocationStatus status;
  final String? error;

  const LocationResult({required this.status, this.location, this.error});
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Request permission and get current GPS location
  Future<LocationResult> getCurrentLocation() async {
    // Check if location service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationResult(
        status: LocationStatus.unavailable,
        error: 'Location services are disabled. Please enable GPS.',
      );
    }

    // Check / request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const LocationResult(
          status: LocationStatus.permissionDenied,
          error: 'Location permission denied.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationResult(
        status: LocationStatus.permissionDenied,
        error: 'Location permission permanently denied. Enable in Settings.',
      );
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LocationInfo(
        parkName: '',       // Will be filled by reverse geocode if needed
        block: 'Current Location',
        latitude: pos.latitude,
        longitude: pos.longitude,
      );

      return LocationResult(status: LocationStatus.success, location: location);
    } catch (e) {
      return LocationResult(
        status: LocationStatus.unavailable,
        error: 'Could not get location: $e',
      );
    }
  }

  /// Stream live location updates
  Stream<Position> getLiveLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // update every 10 metres
      ),
    );
  }
}
