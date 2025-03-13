import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/firebase_options.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveTokenToFirestore(String? token,int userId) async {
  if (token == null) return;

  // Create a unique document for each user (optional: use user ID if authenticated)
  await FirebaseFirestore.instance.collection('tokens').doc(token).set({
    'token': token,
    'userId': userId, // Store user ID (optional: use user ID if authenticated)
    'createdAt': FieldValue.serverTimestamp(), // Store timestamp
  });

  print("Token saved to Firestore");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase .initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use Firebase options
  );
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('auth_token');
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(sound: true,badge: true,alert: true);
    String? token =  await FirebaseMessaging.instance.getToken();
    print(token);
    // saveTokenToFirestore(token);

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        // print('token');
    },);

  await FirebaseMessaging.instance.subscribeToTopic('news');
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