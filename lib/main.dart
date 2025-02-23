import 'package:flutter/material.dart';
import 'package:jawda/screens/laundry_screen.dart';
import 'package:jawda/screens/report_by_shift.dart';
import 'package:provider/provider.dart';
import 'providers/doctor_provider.dart';
import 'screens/login_screen.dart'; // Import LoginScreen
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('auth_token');

  runApp(
    ChangeNotifierProvider(
      create: (context) => DoctorProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doctors App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: authToken != null ? LaundryScreen() : LoginScreen(), // Check for token
      ),
    ),
  );
}