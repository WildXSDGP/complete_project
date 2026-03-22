import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class BackendService {
  static final BackendService _instance = BackendService._internal();
  factory BackendService() => _instance;
  BackendService._internal();

  // Chrome: 'http://localhost:3000'
  // Android phone (same WiFi): 'http://YOUR_PC_IP:3000'
  static const String _baseUrl = 'http://localhost:3000';

  Future<void> loginToBackend() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final String? token = await user.getIdToken(true);
      if (token == null) return;

      await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'firebaseToken': token}),
      ).timeout(const Duration(seconds: 10));
    } catch (_) {
      // silently fail — auth already succeeded in Firebase
    }
  }
}
