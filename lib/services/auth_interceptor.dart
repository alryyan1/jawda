import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get the auth token from shared preferences
    final token = await _getToken();

    if (token != null) {
      // Add the token to the Authorization header
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
  

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}