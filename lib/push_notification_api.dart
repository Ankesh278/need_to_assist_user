import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PushApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Foreground Message: ${message.notification?.title}');
      await saveNotification(message);
    });

    // Handle when notification is tapped (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('Notification Clicked (Background): ${message.notification?.title}');
      await saveNotification(message);
    });
  }

  // Save notification to SharedPreferences
  Future<void> saveNotification(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];

    // Create notification object
    Map<String, String?> newNotification = {
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': jsonEncode(message.data),
    };

    // Add new notification to list
    notifications.insert(0, jsonEncode(newNotification)); // Newest first
    await prefs.setStringList('notifications', notifications);
  }
}

// Background handler must be a top-level function
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background Message: ${message.notification?.title}');
  await PushApi().saveNotification(message); // Save it
}
