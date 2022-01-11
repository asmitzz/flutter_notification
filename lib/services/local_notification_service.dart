import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      int id = 544;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("testing", "testing channel",
              channelDescription: "This is our channel",
              priority: Priority.high,
              importance: Importance.max));

      await _notificationPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails);
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
