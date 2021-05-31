import 'dart:async';

import 'package:location/location.dart';

class CaptureService {
  final _captureController = StreamController<String>();
  Stream<String> get captureStream => _captureController.stream;

  List<String> _failedCaptures = [];

  CaptureService() {
    captureStream.listen((event) async {
      _sendCapture();
    });
  }

  capture(String? sessionId, String image) {
    _captureController.add(image);
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

  void dispose() {
    _captureController.close();
  }
}
