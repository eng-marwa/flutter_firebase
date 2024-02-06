import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iti_flutter/NotificationHandler.dart';
import 'package:iti_flutter/app_screen.dart';
import 'package:iti_flutter/splash.dart';

import 'firebase_options.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print(token);
  //send to backend
  NotificationHandler.handleForegroundNotification();
  FirebaseMessaging.onBackgroundMessage(_backgroundNotificationHandler);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const MyApp());
}
Future _backgroundNotificationHandler(RemoteMessage message) async{
  print(message.notification?.title);
  print(message.notification?.body);
  print(message.data);
  NotificationHandler.viewNotifications(message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => MyHomePage(),
        '/app': (context) => AppScreen()
      },
    );
  }
}
