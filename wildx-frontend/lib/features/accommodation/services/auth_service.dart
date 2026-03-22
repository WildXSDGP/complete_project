import 'api_service.dart';

class AuthService {
  // Register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });

    if (response['success'] == true) {
      ApiService.setToken(response['data']['token']);
    }

    return response;
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (response['success'] == true) {
      ApiService.setToken(response['data']['token']);
    }

    return response;
  }

  // Logout
  static void logout() {
    ApiService.clearToken();
  }
}
