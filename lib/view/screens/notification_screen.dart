import 'package:flutter/material.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedNotifications = prefs.getStringList('notifications') ?? [];

    setState(() {
      notifications = storedNotifications.map((e) =>  Map<String, dynamic>.from(jsonDecode(e)))
          .toList();

    });
  }

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.background,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: ColorUtils.background ,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: clearNotifications,
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No notifications yet'))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification['title'] ?? 'No Title'),
            subtitle: Text(notification['body'] ?? 'No Body'),
          );
        },
      ),
    );
  }
}
