import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static void handleForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification?.title);
      print(message.notification?.body);
      print(message.data);
      viewNotifications(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.notification?.title);
      print(message.notification?.body);
      print(message.data);
      viewNotifications(message);
    });
  }

  static Future<void> viewNotifications(RemoteMessage message) async {
    AndroidBitmap<Object> bitmap =
        const DrawableResourceAndroidBitmap('app_icon');
    String channelId = 'myChannel';
    String channelName = "com.example.iti_flutter";
    print('view notification');
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await plugin.initialize(initializationSettings);
    bool? permission = await AndroidFlutterLocalNotificationsPlugin().requestNotificationsPermission();
    print('plugin initalized');
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            ticker: 'Message Ticker',);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    plugin.show(message.hashCode, message.notification?.title,
        message.notification?.body, notificationDetails);
    print('plugin details');
  }
}
