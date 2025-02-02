import 'dart:async';
import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentScreenIndex = 0;
  int get currentScreenIndex => _currentScreenIndex;

  final List<String> illustrations = [
    'assets/images/splash_screen/ds1.png',
    'assets/images/splash_screen/ds2.png',
    'assets/images/splash_screen/ds3.png',
  ];

  OnboardingProvider() {
    startAutoSlide();
  }

  void startAutoSlide() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      int newIndex = (_currentScreenIndex + 1) % illustrations.length;
      if (newIndex != _currentScreenIndex) {
        _currentScreenIndex = newIndex;
        notifyListeners();
      }
    });
  }

}

