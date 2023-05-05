import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:last_assignment/firebase_options.dart';
import 'router.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  print("TOKEN");
  messaging.getToken().then((value) => print(value));
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await NotificationService().init();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.title}');
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('last_assignment', 'last_assignment');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
       NotificationService.flutterLocalNotificationsPlugin.show(
          12345, message.notification!.title, message.notification!.body,
          platformChannelSpecifics);
    }
  });

  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    builder: (context, child) => MyApp(),
  ));
  // runApp(const MyApp());
}

void _showNotification(RemoteMessage message) async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Product Sans',
      ),
      routerConfig: router,
    );
  }
}
