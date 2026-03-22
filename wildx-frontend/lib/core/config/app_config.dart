library;
import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  // Auto-detect platform — no manual change needed!
  static String get backendUrl {
    if (kIsWeb) return 'http://localhost:3000';          // Chrome
    return 'http://10.0.2.2:3000';                       // Android emulator
    // Real phone same WiFi: change to 'http://YOUR_PC_IP:3000'
  }

  static const String firebaseProjectId = 'wildx-6d2ef';

  static String get apiBase       => '$backendUrl/api';
  static String get authBase      => '$apiBase/auth';
  static String get usersBase     => '$apiBase/users';
  static String get parksBase     => '$apiBase/national-parks';
  static String get sightingsBase => '$apiBase/sightings';
  static String get sightingReports => '$apiBase/sightings/reports';
  static String get sosBase       => '$apiBase/sos';
  static String get emergencyBase => '$apiBase/emergency';
  static String get galleryBase   => '$backendUrl/api/v1';
  static String get notifBase     => '$backendUrl/api/v1/notifications';
  static String get accommBase    => '$backendUrl/api/v1/accommodations';
  static String get bookingsBase  => '$backendUrl/api/v1/bookings';
  static String get markersBase   => '$apiBase/markers';
}
