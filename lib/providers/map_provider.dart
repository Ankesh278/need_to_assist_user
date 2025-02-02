import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapProvider extends ChangeNotifier {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  LatLng _currentPosition = const LatLng(28.6161, 77.3906); // Default location
  bool _locationFetched = false;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(28.6161, 77.3906),
    zoom: 14.0,
  );

  LatLng get currentPosition => _currentPosition;
  bool get locationFetched => _locationFetched;
  Completer<GoogleMapController> get controller => _controller;

  Future<void> getUserLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _currentPosition = LatLng(position.latitude, position.longitude);
      _locationFetched = true;
      notifyListeners();

      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 15.0),
      ));
    } else {
      debugPrint("Location permission denied");
    }
  }

  void setMapController(GoogleMapController controller) {
    _controller.complete(controller);
  }
}
