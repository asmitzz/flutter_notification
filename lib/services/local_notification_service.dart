import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      int id = DateTime.now().millisecondsSinceEpoch~/10000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("testing", "testing channel",
              channelDescription: "This is our channel",
              priority: Priority.high,
              importance: Importance.max));

      await _notificationPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data["route"]);
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
