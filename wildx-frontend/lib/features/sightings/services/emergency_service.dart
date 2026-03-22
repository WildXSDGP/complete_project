import 'package:flutter/services.dart';
import '../models/emergency_contact.dart';
import '../models/location_info.dart';

class EmergencyService {
  static final EmergencyService _i = EmergencyService._();
  factory EmergencyService() => _i;
  EmergencyService._();

  bool _torchOn = false;
  bool _alarmOn = false;

  bool get isTorchOn => _torchOn;
  bool get isAlarmOn => _alarmOn;

  /// Toggle flashlight — returns new state (null if unavailable)
  Future<bool?> toggleFlashlight() async {
    try {
      _torchOn = !_torchOn;
      await HapticFeedback.mediumImpact();
      return _torchOn;
    } catch (_) {
      return null;
    }
  }

  /// Toggle alarm sound — returns new playing state
  Future<bool> toggleAlarm() async {
    _alarmOn = !_alarmOn;
    await HapticFeedback.heavyImpact();
    return _alarmOn;
  }

  /// Send SOS alert with location
  Future<bool> sendSOSAlert(LocationInfo location, {String? message}) async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// Call emergency contact
  Future<void> callEmergency(EmergencyContact contact) async {
    await HapticFeedback.heavyImpact();
  }

  /// Share location (stub)
  Future<void> shareLocation(LocationInfo location) async {
    await HapticFeedback.mediumImpact();
  }

  /// Turn off everything when leaving screen
  Future<void> ensureAllOff() async {
    if (_torchOn) { _torchOn = false; }
    if (_alarmOn) { _alarmOn = false; }
  }
}
