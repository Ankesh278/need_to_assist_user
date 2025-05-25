import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  Box<dynamic>? _box;

  Future<void> _initBox() async {
    if (_box == null || !_box!.isOpen) {
      if (Hive.isBoxOpen('userBox')) {
        _box = Hive.box<UserModel>('userBox');
      } else {
        _box = await Hive.openBox<UserModel>('userBox');
      }
    }
  }


  Future<void> loadUserData() async {
    await _initBox();
    final data = _box?.get('userBox');
    if (data is UserModel) {
      _user = data;
      notifyListeners();
    }
  }


  Future<void> saveUserData(UserModel user) async {
    await _initBox();
    _user = user;
    await _box?.put('userBox', user);
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(user.phoneNumber)
        .set(user.toMap());
    notifyListeners();
  }


  Future<void> saveTokenUser({required String uid, required String token}) async {
    var tokenBox = Hive.isBoxOpen('tokenBox') ? Hive.box('tokenBox') : await Hive.openBox('tokenBox');
    await tokenBox.put('uid', uid);
    await tokenBox.put('token', token);
    notifyListeners();
  }
  Future<String?> getUid() async {
    final box = Hive.isBoxOpen('tokenBox') ? Hive.box('tokenBox') : await Hive.openBox('tokenBox');
    return box.get('uid');
  }



  Future<void> fetchUserFromFirestore(String phoneNumber) async {
    await _initBox();
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(phoneNumber)
        .get();
    if (doc.exists) {
      _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      await _box?.put('userData', _user!);
      notifyListeners();
    }
  }

  String? get uid => _box?.get('uid');
  String? get token => _box?.get('token');
}
