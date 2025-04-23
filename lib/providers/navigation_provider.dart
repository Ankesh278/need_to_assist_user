import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigate to a new screen
  void navigateTo(String routeName, {Object? arguments}) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
    }
  }

  /// Navigate to a new screen and remove previous screens from the stack
  void navigateAndRemoveUntil(String routeName) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName,
            (route) => false,
      );
    }
  }
  /// Navigate to a screen and replace the current one
  void pushReplacement(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Navigate back if possible
  void goBack() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState!.pop();
    }
  }

  /// Selected index for bottom navigation or tab bar
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
