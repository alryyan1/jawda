import 'package:flutter/material.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/doctor.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:jawda/providers/deposit_provider.dart';
import 'package:jawda/providers/item_provider.dart';
import 'package:jawda/providers/shift_provider.dart';
import 'package:jawda/providers/supplier_provider.dart';
import 'package:jawda/services/sockets.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'providers/doctor_provider.dart';
import 'screens/login_screen.dart'; // Import LoginScreen
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('auth_token');
 // Dart client

  SocketService();
  runApp(
    MultiProvider(
       providers: [
        ChangeNotifierProvider(create:  (context) {
          return ClientProvider();
        },),
        ChangeNotifierProvider(create: (context)=> SupplierProvider()),
        ChangeNotifierProvider(create: (context)=> DepositProvider()),
        ChangeNotifierProvider(create: (context)=> ItemProvider()),
        ChangeNotifierProvider(create: (context)=> DoctorProvider()),
       
        ChangeNotifierProvider(create: (context){
          return ShiftProvider();
        })
         
       ],
       
      child: MaterialApp(
        title: 'Doctors App', 
        theme: ThemeData(
          textTheme: TextTheme(
            
          ),
          primarySwatch: Colors.blue,
        ),
        home: authToken != null ? MainScreen() : LoginScreen(), // Check for token
      ),
    ),
  );
}