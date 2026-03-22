import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_config.dart';

class BackendService {
  BackendService._();
  static final BackendService instance = BackendService._();
  factory BackendService() => instance;

  // ── Sync Firebase user → Neon users table ──────────────────
  Future<Map<String, dynamic>?> syncUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        dev.log('[BackendService] No Firebase user — skipping sync');
        return null;
      }

      final url = '${AppConfig.authBase}/firebase/login';
      dev.log('[BackendService] Syncing user to: $url');

      final res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firebaseUid':  user.uid,
          'email':        user.email,
          'phoneNumber':  user.phoneNumber,
          'displayName':  user.displayName,
          'photoUrl':     user.photoURL,
          'authProvider': user.providerData.isNotEmpty
                            ? user.providerData.first.providerId
                            : 'email',
        }),
      ).timeout(const Duration(seconds: 10));

      dev.log('[BackendService] Sync response: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        dev.log('[BackendService] ✅ User synced to Neon DB');
        return data['user'] as Map<String, dynamic>?;
      } else {
        dev.log('[BackendService] ❌ Sync failed: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      dev.log('[BackendService] ❌ Sync error: $e');
    }
    return null;
  }

  Future<void> syncUserWithBackend() async => syncUser();

  // ── Generic HTTP helpers ────────────────────────────────────
  Future<Map<String, String>> get _headers async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
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

  Future<http.Response> delete(String url) async =>
      http.delete(Uri.parse(url), headers: await _headers)
          .timeout(const Duration(seconds: 15));

  static dynamic decode(http.Response res) => jsonDecode(res.body);
}
