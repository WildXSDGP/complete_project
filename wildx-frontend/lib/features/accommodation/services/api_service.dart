import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wildx_frontend/core/config/app_config.dart';

class ApiService {
  static String get baseUrl => AppConfig.accommBase;

  static Future<Map<String, String>> get _headers async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final res = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers,
    ).timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }

  static Future<dynamic> delete(String endpoint) async {
    final res = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers,
    ).timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }
}
