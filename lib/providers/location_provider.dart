import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
class LocationProvider extends ChangeNotifier {
  LatLng? _currentPosition;
  String _currentAddress = "Select a location";
  Marker? _marker;
  GoogleMapController? _mapController;

  LatLng? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  Marker? get marker => _marker;

  // 🔹 Function to get the current location
  Future<void> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // ✅ Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    // ✅ Request permission
    permission = await Geolocator.checkPermission();
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
      markerId: MarkerId("currentLocation"),
      position: _currentPosition!,
      infoWindow: InfoWindow(title: "Current Location"),
    );

    // ✅ Save location to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_address", _currentAddress);
    await prefs.setDouble("saved_lat", position.latitude);
    await prefs.setDouble("saved_lng", position.longitude);

    notifyListeners();
  }
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;

      return "${place.street}, ${place.name}, ${place.locality}, ${place.administrativeArea}";
    } catch (e) {
      return "Unknown location";
    }
  }

  // 🔹 Function to update selected location
  Future<void> updateLocation(LatLng position, String address) async {
    _currentPosition = position;
    _currentAddress = address;

    _marker = Marker(
      markerId: MarkerId("selectedLocation"),
      position: _currentPosition!,
      infoWindow: InfoWindow(title: "Selected Location"),
    );


    // ✅ Save location to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_address", _currentAddress);
    await prefs.setDouble("saved_lat", position.latitude);
    await prefs.setDouble("saved_lng", position.longitude);

    notifyListeners();
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
        markerId: MarkerId("savedLocation"),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: "Saved Location"),
      );
    } else {
      _currentAddress = "No saved location";
    }

    notifyListeners();
  }
}
