import 'package:ai_way/locator.dart';
import 'package:ai_way/services/shared-prefs.service.dart';
import 'package:stacked/stacked.dart';

class SettingsModel extends BaseViewModel{
  SharedPrefsService _sharedPrefsService = locator<SharedPrefsService>();

  late String captureApiUrl;
  late String deviceId;
  late int captureInterval;
  bool showSettings = false;

  Future<void> getSettings() async {
    deviceId = await _sharedPrefsService.getDeviceId();
    captureApiUrl = await _sharedPrefsService.getCaptureApiUrl();
    captureInterval = await _sharedPrefsService.getIntervalCapture();

    showSettings = true;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    await _sharedPrefsService.setCaptureApiUrl(captureApiUrl);
    await _sharedPrefsService.setDeviceId(deviceId);
    await _sharedPrefsService.setCaptureInterval(captureInterval);
  }
}
