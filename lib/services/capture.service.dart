import 'dart:async';

import 'package:location/location.dart';

class CaptureService {
  List<String> _failedCaptures = [];

  int _totalCaptures = 0;

  int get totalCaptures => _totalCaptures;

  capture(String? sessionId, String base64Image) async {
    _totalCaptures++;
  }

  reset() {
    _totalCaptures = 0;
  }

  Future<void> _sendCapture() async {
    var location = await _getCurrentLocation();
    print(location!.longitude.toString());
    print(location.latitude.toString());
  }

  Future<LocationData?> _getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }
}
