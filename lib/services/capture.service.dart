import 'dart:async';

import 'package:ai_way/constants/constants.dart';
import 'package:ai_way/models/capture.model.dart';
import 'package:ai_way/utils/image-utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:sensors_plus/sensors_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../locator.dart';
import 'shared-prefs.service.dart';

class CaptureService with ReactiveServiceMixin {
  SharedPrefsService _sharedPrefsService = locator<SharedPrefsService>();
  String _baseApiUrl = Constants.baseApiUrl;

  final int _imgWidth = 600;
  final int _imgHeight = 600;

  List<Capture> _failedCaptures = [];

  Timer? _failedCapturesTimer;
  StreamSubscription<Position>? _positionStream;

  Rect? captureArea;

  CaptureService() {
    if (_failedCapturesTimer != null) {
      _failedCapturesTimer!.cancel();
    }
    _failedCapturesTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _checkFailedCaptures());
    listenToReactiveValues([_captureCount, _failedCapturesCount, _currentPosition]);

    /*accelerometerEvents.listen((AccelerometerEvent event) {
      print(event);
    });*/
  }

  ReactiveValue<int> _captureCount = ReactiveValue<int>(0);
  ReactiveValue<int> _failedCapturesCount = ReactiveValue<int>(0);
  ReactiveValue<Position?> _currentPosition = ReactiveValue<Position?>(null);

  int get captureCount => _captureCount.value;

  int get failedCapturesCount => _failedCapturesCount.value;

  Position? get currentLocation => _currentPosition.value;

  double? get currentSpeed => _currentPosition.value != null ? _currentPosition.value!.speed * 3.6 : null;

  capture(String? sessionId, String imagePath) async {
    /*Position? capturePosition;
    try {
      capturePosition = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      capturePosition = null;
    }

    if (capturePosition != null && capturePosition.speed * 3.6 < 5.0) {
      return;
    }*/

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
      _currentPosition.value != null ? _currentPosition.value!.latitude : 0.0,
      _currentPosition.value != null ? _currentPosition.value!.longitude : 0.0,
      _currentPosition.value != null ? _currentPosition.value!.heading : 0.0,
      currentFormattedDate,
      base64Image,
    );

    try {
      var url = Uri.parse('$_baseApiUrl/api/v1/image');
      var response = await http.post(url, body: capture.toJson());
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
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

  listenToLocationChange() async {
    cancelLocationSubscription();

    _positionStream = Geolocator.getPositionStream(
      forceAndroidLocationManager: true,
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    ).listen((Position position) {
      _currentPosition.value = position;
    }, onError: (_) {
      _currentPosition.value = null;
    });
  }

  reset() {
    _captureCount.value = 0;
    captureArea = null;
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

  cancelLocationSubscription() {
    if (_positionStream != null) {
      _positionStream!.cancel();
      _positionStream = null;
      _currentPosition.value = null;
    }
  }
}
