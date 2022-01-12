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
  final List<Message> _messages = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    // If the message also contains a data property with a "route",
    // navigate to that route
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    /// receive message in foreground only
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
      _addMessage(message);
    });

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    _addMessage(message);

    Navigator.pushNamed(
      context,
      message.data['route'],
    );
  }

  void _getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    print(token);
  }

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context);

    setupInteractedMessage();
    _getDeviceToken();
  }

  void _addMessage(RemoteMessage message) {
    Message msg = Message(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        message: message.data["message"]);
    _messages.add(msg);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
      child: _messages.isEmpty
          ? const Text("No Notifications received")
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                Message msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        msg.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
    )));
  }
}

class Message {
  final String title;
  final String body;
  final String message;

  Message({required this.title, required this.body, required this.message});
}
