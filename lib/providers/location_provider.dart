import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _currentPosition;
  String _currentAddress = "Select a location";
  Marker? _marker;
  GoogleMapController? _mapController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  LatLng? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  Marker? get marker => _marker;

  // 🔹 Function to get the current location
  Future<void> getCurrentLocation(BuildContext context) async {
    User? user = _auth.currentUser;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }
    }

    // ✅ Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentPosition = LatLng(position.latitude, position.longitude);
    String address = await _getAddressFromLatLng(position.latitude, position.longitude);
    _currentAddress = address;

    // ✅ Update the marker
    _marker = Marker(
      markerId: const MarkerId("currentLocation"),
      position: _currentPosition!,
      infoWindow: const InfoWindow(title: "Current Location"),
    );

    // ✅ Save location locally (even if user is not logged in)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_address", _currentAddress);
    await prefs.setDouble("saved_lat", position.latitude);
    await prefs.setDouble("saved_lng", position.longitude);

    // ✅ Save to Firebase ONLY IF user is logged in
    if (user != null) {
      await _firestore.collection("users").doc(user.uid).set({
        "address": _currentAddress,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "timestamp": DateTime.now(),
      }, SetOptions(merge: true));
    }

    notifyListeners();
  }


  // 🔹 Convert coordinates to address
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;
      return "${place.street}, ${place.locality}, ${place.administrativeArea}";
    } catch (e) {
      return "Unknown location";
    }
  }

  // 🔹 Function to update selected location
  Future<void> updateLocation(LatLng position, String address) async {
    User? user = _auth.currentUser;

    _currentPosition = position;
    _currentAddress = address;

    _marker = Marker(
      markerId: const MarkerId("selectedLocation"),
      position: _currentPosition!,
      infoWindow: const InfoWindow(title: "Selected Location"),
    );

    // ✅ Save location locally (even if user is not logged in)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_address", _currentAddress);
    await prefs.setDouble("saved_lat", position.latitude);
    await prefs.setDouble("saved_lng", position.longitude);

    // ✅ Save to Firebase **ONLY IF user is logged in**
    if (user != null) {
      await _firestore.collection("users").doc(user.uid).set({
        "address": _currentAddress,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "timestamp": DateTime.now(),
      }, SetOptions(merge: true));
    }

    notifyListeners();

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition!,
            zoom: 16.0,
          ),
        ),
      );
    }
  }



  // 🔹 Load saved location on app restart
  Future<void> loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble("saved_lat");
    double? lng = prefs.getDouble("saved_lng");
    String? address = prefs.getString("saved_address");

    if (lat != null && lng != null && address != null) {
      _currentPosition = LatLng(lat, lng);
      _currentAddress = address;
      _marker = Marker(
        markerId: const MarkerId("savedLocation"),
        position: _currentPosition!,
        infoWindow: const InfoWindow(title: "Saved Location"),
      );
    } else {
      _currentAddress = "No saved location";
    }

    notifyListeners();
  }
  void clearLocation() {
    _currentPosition = null;
    _currentAddress = "Select a location";
    _marker = null;
    notifyListeners();
  }
}
