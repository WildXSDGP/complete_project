import 'dart:convert';
import '../models/animal_type1.dart';
import '../models/location_info1.dart';
import 'package:wildx_frontend/core/config/app_config.dart';
import 'package:wildx_frontend/core/services/backend_service.dart';

class SightingService {
  static final SightingService instance = SightingService._();
  SightingService._();
  factory SightingService() => instance;

  // Submit a sighting report using SightingReport model fields
  Future<bool> submitReport({
    required AnimalType animalType,
    String? photoPath,
    required LocationInfo location,
    String? notes,
  }) async {
    try {
      final res = await BackendService.instance.post(
        '${AppConfig.sightingsBase}/reports',
        {
          'flutterReportId': 'fr_${DateTime.now().millisecondsSinceEpoch}',
          'animalTypeId':    animalType.name,
          'animalTypeName':  animalType.label,
          'animalCategory':  animalType.name.toUpperCase(),
          'locationName':    location.name,
          'latitude':        location.latitude,
          'longitude':       location.longitude,
          'isCurrentLocation': true,
          'photoPath':       photoPath,
          'notes':           notes,
          'sightingTime':    DateTime.now().toIso8601String(),
          'status':          'SUBMITTED',
        },
      );
      return res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // Submit to sightings table
  Future<bool> submitSighting({
    required AnimalType animalType,
    String? photoUrl,
    required LocationInfo location,
    String? notes,
  }) async {
    try {
      final res = await BackendService.instance.post(
        AppConfig.sightingsBase,
        {
          'id':              's_${DateTime.now().millisecondsSinceEpoch}',
          'animalTypeId':    animalType.name,
          'animalTypeName':  animalType.label,
          'animalTypeEmoji': animalType.emoji,
          'animalCategory':  'MAMMAL',
          'locationName':    location.name,
          'latitude':        location.latitude,
          'longitude':       location.longitude,
          'photoUrl':        photoUrl,
          'notes':           notes,
          'sightingTime':    DateTime.now().toIso8601String(),
          'status':          'PENDING',
        },
      );
      return res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // GET all sightings
  Future<List<Map<String, dynamic>>> getSightings() async {
    try {
      final res = await BackendService.instance.get(AppConfig.sightingsBase);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data['sightings'] ?? []);
      }
    } catch (_) {}
    return [];
  }
}
