import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/firebase_options.dart';
import 'package:jawda/models/doctor.dart';
import 'package:jawda/models/petty_cash.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:jawda/providers/deposit_provider.dart';
import 'package:jawda/providers/item_provider.dart';
import 'package:jawda/providers/lab_provider.dart';
import 'package:jawda/providers/shift_provider.dart';
import 'package:jawda/providers/supplier_provider.dart';
import 'package:jawda/screens/petty_approve_screen.dart';
import 'package:jawda/services/sockets.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'providers/doctor_provider.dart';
import 'screens/login_screen.dart'; // Import LoginScreen
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();
final scaffoledMessangerState = GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage? message) async{
  if(message == null) return;
  print(message.data);
  nav.currentState!.pushNamed('expenseApprove',arguments: message.data['id']);
  print("Background Message: ${message.notification?.body}");
  print("Background Message: ${message.notification?.title}");
}
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
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,sound: true,badge: true);
    String? token =  await FirebaseMessaging.instance.getToken();
    // print(token);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.instance.getInitialMessage().then(onBackgroundMessage);
     // Listen for foreground messages


    FirebaseMessaging.onMessageOpenedApp.listen(onBackgroundMessage);
    // saveTokenToFirestore(token);

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        // print('token');
    },);

  await FirebaseMessaging.instance.subscribeToTopic('tests');
 // Dart client

  SocketService();
  runApp(
    MultiProvider(
       providers: [
        ChangeNotifierProvider(create:  (context) {
          return ClientProvider();
        },),
        ChangeNotifierProvider(create: (context)=> LabProvider()),
        ChangeNotifierProvider(create: (context)=> SupplierProvider()),
        ChangeNotifierProvider(create: (context)=> DepositProvider()),
        ChangeNotifierProvider(create: (context)=> ItemProvider()),
        ChangeNotifierProvider(create: (context)=> DoctorProvider()),
       
        ChangeNotifierProvider(create: (context){
          return ShiftProvider();
        })
         
       ],
       
      child:MyApp()
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
       // Listen for foreground messages
   // Ensure it runs after the first frame

  }
 

  @override
  Widget build(BuildContext context) {
   return ToastificationWrapper(child: MaterialApp(
        navigatorKey: nav,
        scaffoldMessengerKey: scaffoledMessangerState,  // Use the global key for navigation
        title: 'Doctors App', 
        onGenerateRoute: (settings) {
          if(settings.name == 'login'){
            return MaterialPageRoute(builder: (context) {
              return LoginScreen();
            },);
          }
          if(settings.name == 'expenseApprove'){
            return MaterialPageRoute(builder: (context) {
              final expenseId = settings.arguments ;
              return PettyApproveScreen(expense: null, onUpdate: null,id: expenseId as String);
            },);
          }
          return MaterialPageRoute(builder: (context) => MainScreen(),);
        },
        theme: ThemeData(
          textTheme: TextTheme(
            
          ),
          primarySwatch: Colors.blue,
        ),
        home: Home(), // Check for token
      ),);
    
  }
}

void handleFirebaseMessage(BuildContext context , RemoteMessage message){
      
    
   Toastification().show(
    context: context,
    title: Text(message.notification?.title ?? 'عنوان'),
   description:Text(message.notification?.body ?? 'اشعار جديد'),
    autoCloseDuration: Duration(seconds: 5),
    callbacks: ToastificationCallbacks(
      onTap: (value) => nav.currentState!.pushNamed('expenseApprove',arguments: message.data['id']),
    )
   );
  //  ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message.notification?.body ?? "New Notification"),
  //       duration: Duration(seconds: 5),
  //     ),
  //   );

}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? authToken;

    Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('auth_token'); // Retrieve token
      if(mounted){
           FirebaseMessaging.onMessage.listen((message) {
          handleFirebaseMessage(context, message);
      },);
      }
   
    });
  }
  @override
  void initState() {
    super.initState();
    loadAuthToken();
    

  }
  @override
  Widget build(BuildContext context) {

    return authToken != null ? MainScreen() : LoginScreen();
  }
}