import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  // Load user data from Hive (Offline Storage)
  Future<void> loadUserData() async {
    var box = await Hive.openBox<UserModel>('userBox');
    _user = box.get('userData');
    notifyListeners();
  }

  // Save user data locally & sync with Firestore
  Future<void> saveUserData(UserModel user) async {
    _user = user;

    // Save offline (Hive)
    var box = await Hive.openBox<UserModel>('userBox');
    box.put('userData', user);

    // Save online (Firestore)
    await FirebaseFirestore.instance.collection('users').doc(user.phoneNumber).set(user.toMap());

    notifyListeners();
  }

  // Fetch user data from Firestore (if online)
  Future<void> fetchUserFromFirestore(String phoneNumber) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(phoneNumber).get();
    if (doc.exists) {
      _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      notifyListeners();

      // Save in Hive for offline use
      var box = await Hive.openBox<UserModel>('userBox');
      box.put('userData', _user!);
    }
  }
}
