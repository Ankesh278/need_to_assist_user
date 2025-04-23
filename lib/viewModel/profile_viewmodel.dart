import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  ProfileModel _profile = ProfileModel(name: 'Name', imageUrl: '');
  ProfileModel get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProfileViewModel() {
    loadUserProfile();
  }


  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedName = prefs.getString('profile_name');
    String? cachedImageUrl = prefs.getString('profile_image');

    if (cachedName != null && cachedImageUrl != null) {
      _profile = ProfileModel(name: cachedName, imageUrl: cachedImageUrl);
      notifyListeners();
    }

    // Fetch latest data from Firebase
    await fetchProfileFromFirebase();
  }

  Future<void> fetchProfileFromFirebase() async {
    String uid = _auth.currentUser!.uid;
    DocumentReference userRef = _firestore.collection('users').doc(uid);

    try {
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        _profile = ProfileModel.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        // Create a new document if not found
        await userRef.set({'name': 'New User', 'imageUrl': ''});
        _profile = ProfileModel(name: 'New User', imageUrl: '');
      }

      await _saveProfileToLocal(_profile.name, _profile.imageUrl);
      await _loadProfileFromLocal();
      notifyListeners();
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> _saveProfileToLocal(String name, String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_image', imageUrl);
  }

  Future<void> _loadProfileFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    _profile.name = prefs.getString('profile_name') ?? 'User';
    _profile.imageUrl = prefs.getString('profile_image') ?? '';

    notifyListeners();
  }

  Future<void> updateProfileName(String newName) async {
    String uid = _auth.currentUser!.uid;
    DocumentReference userRef = _firestore.collection('users').doc(uid);

    try {
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        await userRef.update({'name': newName});
      } else {
        await userRef.set({'name': newName, 'imageUrl': _profile.imageUrl});
      }

      _profile.name = newName;
      await _saveProfileToLocal(newName, _profile.imageUrl);
      notifyListeners();
    } catch (e) {
      print('Error updating profile name: $e');
    }
  }

  Future<void> updateProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _isLoading = true;
      notifyListeners();

      File imageFile = File(pickedFile.path);
      String uid = _auth.currentUser!.uid;
      Reference storageRef = _storage.ref().child('profile_images/$uid.jpg');

      try {
        // Upload the image
        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Update in Firestore
        await _firestore.collection('users').doc(uid).update({'imageUrl': imageUrl});

        // Update locally
        _profile.imageUrl = imageUrl;
        await _saveProfileToLocal(_profile.name, imageUrl);

        notifyListeners();
      } catch (e) {
        print('Error uploading profile image: $e');
      }

      _isLoading = false;
      notifyListeners();
    }
  }


}
