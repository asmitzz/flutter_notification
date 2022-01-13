import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final void Function(RemoteMessage)? onMessage;
  final void Function(RemoteMessage) handleInitialMessage;
  final void Function(RemoteMessage) onMessageOpenedApp;

  FirebaseMessagingService(
      {required this.onMessage,
      required this.onMessageOpenedApp,
      required this.handleInitialMessage});

  static Future<String?> getDeviceToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    return token;
  }

   Future<void> init() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    // If the message also contains a data property with a "route",
    // navigate to that route
    if (initialMessage != null) {
      handleInitialMessage(initialMessage);
    }

    /// receive message in foreground only
    FirebaseMessaging.onMessage.listen(onMessage);

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
  }
}
