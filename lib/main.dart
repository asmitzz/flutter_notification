import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/screens/cart_screen.dart';
import 'package:flutter_notification/screens/wishlist_screen.dart';
import 'package:flutter_notification/services/local_notification_service.dart';

Future<void> handleBackgroundMessage(message) async {
  print("received message");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notifications Example',
      routes: {
        "/": (context) => const MyHomePage(),
        "/wishlist": (context) => const WishlistScreen(),
        "/cart": (context) => const CartScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "route",
    // navigate to that route
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    /// receive message in foreground only
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification?.body);
      print(message.notification?.title);

      LocalNotificationService.display(message);
    });

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Navigator.pushNamed(
      context,
      message.data['route'],
    );
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
            body: Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "You will receive a notification soon",
          style: TextStyle(fontSize: 34),
        ),
      ),
    )));
  }
}
