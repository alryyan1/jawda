import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jawda/main.dart';

class ErrorInterceptor extends Interceptor {
  final BuildContext context;

  ErrorInterceptor(this.context);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = _getErrorMessage(err);

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 13),
      ),
    );
    if(err.response!.statusCode == 411){
      nav.currentState!.pushNamed('login');

    }
    // Logout if token expired
    return handler.next(err); // Continue handling the error
  }

  String _getErrorMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet.";
      case DioExceptionType.sendTimeout:
        return "Request timed out. Try again.";
      case DioExceptionType.receiveTimeout:
        return "Server response timeout.";
      case DioExceptionType.badCertificate:
        return "Invalid certificate from the server.";
      case DioExceptionType.badResponse:
        return "Server error: ${err.response?.data['message']}";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      case DioExceptionType.connectionError:
        return "No internet connection.";      
      case DioExceptionType.unknown:
      default:
        return "An unexpected error occurred.";
    }
  }
}
