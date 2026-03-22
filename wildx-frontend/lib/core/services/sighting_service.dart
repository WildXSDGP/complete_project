import 'dart:convert';
import 'package:wildx_frontend/core/config/app_config.dart';
import 'package:wildx_frontend/core/services/backend_service.dart';

class SightingService {
  static final _svc = BackendService.instance;

  static Future<List<Map<String, dynamic>>> getAllSightings() async {
    try {
      final res = await _svc.get(AppConfig.sightingsBase);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data['sightings'] ?? []);
      }
    } catch (_) {}
    return [];
  }

  // Submit a sighting → sightings table
  static Future<bool> submitSighting({
    required String animalTypeId,
    required String animalTypeName,
    String? animalTypeEmoji,
    String? animalCategory,
    required String locationName,
    required double latitude,
    required double longitude,
    String? photoUrl,
    String? notes,
  }) async {
    try {
      final res = await _svc.post(AppConfig.sightingsBase, {
        'animal_type_id':    animalTypeId,
        'animal_type_name':  animalTypeName,
        'animal_type_emoji': animalTypeEmoji,
        'animal_category':   animalCategory,
        'location_name':     locationName,
        'latitude':          latitude,
        'longitude':         longitude,
        'photo_url':         photoUrl,
        'notes':             notes,
        'sighting_time':     DateTime.now().toIso8601String(),
      });
      return res.statusCode == 201;
    } catch (_) { return false; }
  }

  // Submit a detailed report → sighting_reports table
  static Future<bool> submitReport({
    required String animalTypeId,
    required String animalTypeName,
    String? animalCategory,
    required String locationName,
    required double latitude,
    required double longitude,
    bool isCurrentLocation = true,
    String? photoPath,
    String? notes,
    String? flutterReportId,
  }) async {
    try {
      final res = await _svc.post('${AppConfig.sightingsBase}/reports', {
        'flutter_report_id':   flutterReportId,
        'animal_type_id':      animalTypeId,
        'animal_type_name':    animalTypeName,
        'animal_category':     animalCategory,
        'location_name':       locationName,
        'latitude':            latitude,
        'longitude':           longitude,
        'is_current_location': isCurrentLocation,
        'photo_path':          photoPath,
        'notes':               notes,
        'sighting_time':       DateTime.now().toIso8601String(),
      });
      return res.statusCode == 201;
    } catch (_) { return false; }
  }
}
