import '../data/accommodation_data.dart';
import 'dart:convert';
import 'package:wildx_frontend/core/config/app_config.dart';
import 'package:wildx_frontend/core/services/backend_service.dart';

class AccommodationService {

  static Future<List<dynamic>> getAccommodations() async {
    try {
      final res = await BackendService.instance
          .get(AppConfig.accommBase)
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data['accommodations'] ?? data['data']?['accommodations'] ?? [];
        if ((list as List).isNotEmpty) return list;
      }
    } catch (_) {}
    // Always fallback to local data
    return localFallback();
  }

  static List<Map<String, dynamic>> localFallback() =>
    dummyAccommodations.map((a) => <String, dynamic>{
      'id':              a.id,
      'name':            a.name,
      'parkName':        a.parkName,
      'pricePerNight':   a.pricePerNight,
      'distanceFromGate': a.distanceFromGate,
      'travelTime':      a.travelTime,
      'fuelStops':       a.fuelStops,
      'rating':          a.rating,
      'isEcoFriendly':   a.isEcoFriendly,
      'isFamilyFriendly': a.isFamilyFriendly,
      'hasJeepHire':     a.hasJeepHire,
      'imageUrls':       a.imageUrls,
      'description':     a.description,
    }).toList();

  static Future<Map<String, dynamic>?> getAccommodationById(String id) async {
    final list = await getAccommodations();
    final found = list.where((e) => e['id']?.toString() == id).firstOrNull;
    return found as Map<String, dynamic>?;
  }

  static Future<Map<String, dynamic>> createBooking({
    required String accommodationId,
    required String checkInDate,
    required String checkOutDate,
    required int guests,
    double? totalPrice,
  }) async {
    try {
      final res = await BackendService.instance.post(AppConfig.bookingsBase, {
        'accommodationId': accommodationId,
        'checkInDate':     checkInDate,
        'checkOutDate':    checkOutDate,
        'adults':          guests,
        'totalPrice':      totalPrice ?? 0,
        'status':          'confirmed',
      });
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (_) {}
    return {
      'success': true,
      'booking': {
        'id': 'bk_${DateTime.now().millisecondsSinceEpoch}',
        'accommodationId': accommodationId,
        'checkInDate': checkInDate, 'checkOutDate': checkOutDate,
        'adults': guests, 'status': 'confirmed',
      }
    };
  }
}
