import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.background,
      body: Center(child: Text('Notification'),)
    );
  }
}
