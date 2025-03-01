import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/services/error_interceptor.dart';
import 'auth_interceptor.dart'; // Create AuthInterceptor Class

class DioClient {
  static Dio? _dio;

  static Dio getDioInstance(BuildContext context) {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: '${schema}://${host}/${path}/', // Base URL from constants file
        connectTimeout: Duration(seconds: 300),
        receiveTimeout: Duration(seconds: 300),
        contentType: 'application/json',
      ));

      // Add interceptors
      _dio!.interceptors.add(AuthInterceptor()); // Auth Interceptor
      _dio!.interceptors.add(LogInterceptor(responseBody: true)); // Log Interceptor (optional)
      _dio!.interceptors.add(ErrorInterceptor(context)); // Error Interceptor
    }
    return _dio!;
  }

  static Future<String?> getHeaders() async {
    return null;
  }
}