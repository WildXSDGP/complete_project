import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/emergency_contact.dart';
import '../models/location_info.dart';
import 'package:wildx_frontend/core/config/app_config.dart';
import 'package:wildx_frontend/core/services/backend_service.dart';

class EmergencyService {
  static final EmergencyService _i = EmergencyService._();
  factory EmergencyService() => _i;
  EmergencyService._();

  bool _torchOn = false;
  bool _alarmOn = false;

  bool get isTorchOn => _torchOn;
  bool get isAlarmOn => _alarmOn;

  // Toggle flashlight
  Future<bool?> toggleFlashlight() async {
    try {
      _torchOn = !_torchOn;
      await HapticFeedback.mediumImpact();
      return _torchOn;
    } catch (_) { return null; }
  }

  // Toggle alarm
  Future<bool> toggleAlarm() async {
    _alarmOn = !_alarmOn;
    await HapticFeedback.heavyImpact();
    return _alarmOn;
  }

  // Send SOS alert to backend + vibrate
  Future<bool> sendSOSAlert(LocationInfo location, {String? message}) async {
    await HapticFeedback.heavyImpact();
    try {
      await BackendService.instance.post(
        '${AppConfig.sosBase}/alert',
        {
          'userId':    'anonymous',
          'latitude':  location.latitude,
          'longitude': location.longitude,
          'parkName':  location.parkName,
          'message':   message ?? 'Emergency SOS triggered',
          'status':    'pending',
        },
      );
    } catch (_) {}
    return true;
  }

  // Actually call the emergency number
  Future<void> callEmergency(EmergencyContact contact) async {
    await HapticFeedback.heavyImpact();
    final uri = Uri.parse('tel:${contact.number.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Share location via WhatsApp or other apps
  Future<void> shareLocation(LocationInfo location) async {
    await HapticFeedback.mediumImpact();
    final text = Uri.encodeComponent(
      '🚨 WildX SOS! I need help.\n'
      '📍 Location: ${location.parkName}, ${location.block}\n'
      '🗺️ GPS: ${location.coordinates}\n'
      'Google Maps: https://maps.google.com/?q=${location.latitude},${location.longitude}'
    );
    final whatsapp = Uri.parse('whatsapp://send?text=$text');
    final sms = Uri.parse('sms:?body=$text');
    if (await canLaunchUrl(whatsapp)) {
      await launchUrl(whatsapp);
    } else if (await canLaunchUrl(sms)) {
      await launchUrl(sms);
    }
  }

  Future<void> ensureAllOff() async {
    _torchOn = false;
    _alarmOn = false;
  }
}
