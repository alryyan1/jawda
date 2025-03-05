import 'package:flutter/material.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/doctor.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:jawda/providers/deposit_provider.dart';
import 'package:jawda/providers/item_provider.dart';
import 'package:jawda/providers/shift_provider.dart';
import 'package:jawda/providers/socket_provider.dart';
import 'package:jawda/providers/supplier_provider.dart';
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

     IO.Socket  _socket = IO.io('http://192.168.137.1:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      print('Connected to Socket.IO server');
      _socket.emit('msg', 'Flutter app connected');
    });

    _socket.on('flutter', (data) {
        print(data);
    });

    _socket.onDisconnect((_) => print('Disconnected'));
    _socket.onError((err) => print(err));
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
          final socketProvider = SocketProvider();
          socketProvider.connectSocket();
          return socketProvider;
        }),
        ChangeNotifierProvider(create: (context){
          return ShiftProvider();
        })
         
       ],
       
      child: MaterialApp(
        title: 'Doctors App', 
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: authToken != null ? MainScreen() : LoginScreen(), // Check for token
      ),
    ),
  );
}