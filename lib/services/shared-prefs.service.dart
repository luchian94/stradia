import 'dart:io';

import 'package:ai_way/constants/constants.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {

  Future<String> getCaptureApiUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? prefsApiUrl = prefs.getString(Constants.prefsCaptureApiUrlKey);
    return prefsApiUrl != null ? prefsApiUrl : 'https://zstag-rdd-api.azurewebsites.net';
  }

  Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? prefsDeviceId = prefs.getString(Constants.prefsDeviceIdKey);
    if (prefsDeviceId != null) {
      return prefsDeviceId;
    } else {
      return await _getDeviceId();
    }
  }

  Future<int> getIntervalCapture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? prefsCaptureInterval = prefs.getInt(Constants.prefsCaptureIntervalKey);
    return prefsCaptureInterval != null ? prefsCaptureInterval : 5000;
  }

  Future<void> setCaptureApiUrl(String apiUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.prefsCaptureApiUrlKey, apiUrl);
  }

  Future<void> setDeviceId(String deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.prefsDeviceIdKey, deviceId);
  }

  Future<void> setCaptureInterval(int captureInterval) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Constants.prefsCaptureIntervalKey, captureInterval);
  }

  Future<String> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }
}
