import 'package:flutter/services.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Future<void> startAlarm() async {
    if (_isPlaying) return;
    _isPlaying = true;
    HapticFeedback.vibrate();
  }

  Future<void> stopAlarm() async {
    _isPlaying = false;
  }

  Future<bool> toggle() async {
    _isPlaying ? await stopAlarm() : await startAlarm();
    return _isPlaying;
  }

  Future<void> ensureAlarmOff() async {
    if (_isPlaying) await stopAlarm();
  }
}
