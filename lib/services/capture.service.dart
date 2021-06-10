import 'dart:async';

import 'package:flutter/material.dart';
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

  final int _imgWidth = 600;
  final int _imgHeight = 600;

  List<Capture> _failedCaptures = [];

  late Timer _failedCapturesTimer;

  Rect? captureArea;

  CaptureService() {
    _failedCapturesTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _checkFailedCaptures());
    listenToReactiveValues([_captureCount, _failedCapturesCount, _currentLocation]);
  }

  ReactiveValue<int> _captureCount = ReactiveValue<int>(0);
  ReactiveValue<int> _failedCapturesCount = ReactiveValue<int>(0);
  ReactiveValue<LocationData?> _currentLocation = ReactiveValue<LocationData?>(null);

  int get captureCount => _captureCount.value;
  int get failedCapturesCount => _failedCapturesCount.value;
  LocationData? get currentLocation => _currentLocation.value;
  double? get currentSpeed => _currentLocation.value != null && _currentLocation.value!.speed != null ? _currentLocation.value!.speed! * 3.6 : 0.0;

  capture(String? sessionId, String imagePath) async {
    if (currentSpeed != null && currentSpeed! <= 5.0) {
      return;
    }
    DateTime now = DateTime.now();
    String currentFormattedDate = now.toIso8601String();

    String deviceId = await _sharedPrefsService.getDeviceId();

    String base64Image;
    if (captureArea != null) {
      var croppedImage = await ImageProcessor.cropByArea(imagePath, captureArea);
      base64Image = await ImageProcessor.getBase64ResizedImage(croppedImage.path, _imgWidth, _imgHeight);
    } else {
      base64Image = await ImageProcessor.getBase64ResizedImage(imagePath, _imgWidth, _imgHeight);
    }

    Capture capture = Capture(
      deviceId,
      sessionId != null ? sessionId : "",
      _currentLocation.value != null ? _currentLocation.value!.latitude : 0.0,
      _currentLocation.value != null ? _currentLocation.value!.longitude : 0.0,
      _currentLocation.value != null ? _currentLocation.value!.heading : 0.0,
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

  listenToLocationChange() {
    Location location = new Location();

    location.onLocationChanged.listen((LocationData currentLocation) {
      _currentLocation.value = currentLocation;
    });
  }

  reset() {
    _captureCount.value = 0;
  }

  _checkFailedCaptures() {
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
