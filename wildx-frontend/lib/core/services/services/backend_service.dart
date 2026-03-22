import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_config.dart';

class BackendService {
  BackendService._();
  static final BackendService instance = BackendService._();
  factory BackendService() => instance;

  Future<Map<String, String>> get _headers async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Firebase login → sync to Neon DB users table
  Future<void> syncUserWithBackend() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final token = await user.getIdToken(true);

      await http.post(
        Uri.parse('${AppConfig.authBase}/firebase/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firebaseToken': token,
          'firebaseUid':   user.uid,
          'email':         user.email,
          'phoneNumber':   user.phoneNumber,
          'displayName':   user.displayName,
          'photoUrl':      user.photoURL,
          'authProvider':  user.providerData.isNotEmpty
                             ? user.providerData.first.providerId
                             : 'firebase',
        }),
      ).timeout(const Duration(seconds: 10));
    } catch (_) {}
  }

  Future<http.Response> get(String url) async =>
      http.get(Uri.parse(url), headers: await _headers)
          .timeout(const Duration(seconds: 15));

  Future<http.Response> post(String url, Map<String, dynamic> body) async =>
      http.post(Uri.parse(url), headers: await _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

  Future<http.Response> put(String url, Map<String, dynamic> body) async =>
      http.put(Uri.parse(url), headers: await _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

  static dynamic decode(http.Response res) => jsonDecode(res.body);
}
