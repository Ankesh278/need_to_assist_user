import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PushApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $fcmToken');
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('Foreground Message: ${message.notification?.title}');
      }
      await saveNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('Notification Clicked (Background): ${message.notification?.title}');
      }
      await saveNotification(message);
    });
  }

  Future<void> saveNotification(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];

    Map<String, String?> newNotification = {
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': jsonEncode(message.data),
    };

    notifications.insert(0, jsonEncode(newNotification));
    await prefs.setStringList('notifications', notifications);
  }
}

// Background handler must be a top-level function
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background Message: ${message.notification?.title}');
  }
  await PushApi().saveNotification(message);
}
