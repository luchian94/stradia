import 'dart:async';

import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/constants/constants.dart';
import 'package:stradia/models/capture.model.dart';
import 'package:http/http.dart' as http;
import 'package:stradia/services/shared-prefs.service.dart';
import 'package:stradia/utils/image-utils.dart';

import '../locator.dart';

class CaptureService with ReactiveServiceMixin {
  SharedPrefsService _sharedPrefsService = locator<SharedPrefsService>();
  String _baseApiUrl = Constants.baseApiUrl;

  List<Capture> _failedCaptures = [];

  late Timer _failedCapturesTimer;

  CaptureService() {
    _failedCapturesTimer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => checkFailedCaptures());
    listenToReactiveValues([_captureCount, _failedCapturesCount]);
  }

  ReactiveValue<int> _captureCount = ReactiveValue<int>(0);

  int get captureCount => _captureCount.value;

  ReactiveValue<int> _failedCapturesCount = ReactiveValue<int>(0);

  int get failedCapturesCount => _failedCapturesCount.value;

  capture(String? sessionId, String imagePath) async {
    DateTime now = DateTime.now();
    String currentFormattedDate = now.toIso8601String();

    var location = await _getCurrentLocation();
    String base64Image = await ImageProcessor.cropSquare(imagePath);
    String deviceId = await _sharedPrefsService.getDeviceId();

    Capture capture = Capture(
      deviceId,
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
      if (response.statusCode == 201) {
        _captureCount.value++;
      } else {
        _failedCaptures.add(capture);
        _failedCapturesCount.value++;
      }
    } catch (e) {
      _failedCaptures.add(capture);
      _failedCapturesCount.value++;
    }
  }

  reset() {
    _captureCount.value = 0;
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

  checkFailedCaptures() {
    if (_failedCaptures.length > 0) {
      var firstCapture = _failedCaptures[0];
      var url = Uri.parse('$_baseApiUrl/api/v1/image');
      http.post(url, body: firstCapture.toJson()).then((response) {
        if (response.statusCode == 201) {
          _failedCaptures.removeAt(0);
          _captureCount.value++;
          _failedCapturesCount.value--;
        }
      });
    }
  }
}
