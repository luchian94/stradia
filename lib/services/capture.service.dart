import 'dart:async';

import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:stradia/constants/constants.dart';
import 'package:stradia/models/capture.model.dart';
import 'package:http/http.dart' as http;
import 'package:stradia/utils/image-utils.dart';

class CaptureService {
  String _baseApiUrl = Constants.baseApiUrl;

  List<Capture> _failedCaptures = [];

  int _totalCaptures = 0;

  int get totalCaptures => _totalCaptures;

  capture(String? sessionId, String imagePath) async {
    DateTime now = DateTime.now();
    String currentFormattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    var location = await _getCurrentLocation();
    String base64Image = await ImageProcessor.cropSquare(imagePath);

    Capture capture = Capture(
      "test",
      sessionId != null ? sessionId : "",
      location != null ? location.latitude : 0.0,
      location != null ? location.longitude : 0.0,
      location != null ? location.heading : 0.0,
      currentFormattedDate,
      base64Image,
    );

    try {
      var url = Uri.parse('$_baseApiUrl/api/v1/image');
      var response = await http.post(url, body: capture.toJson());
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      _totalCaptures++;
    } catch (e) {
      _failedCaptures.add(capture);
    }
  }

  reset() {
    _totalCaptures = 0;
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
