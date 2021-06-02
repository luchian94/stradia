import 'package:stacked/stacked.dart';
import 'package:stradia/locator.dart';
import 'package:stradia/services/shared-prefs.service.dart';

class SettingsModel extends BaseViewModel{
  SharedPrefsService _sharedPrefsService = locator<SharedPrefsService>();

  late String deviceId;
  late int captureInterval;
  bool showSettings = false;

  Future<void> getSettings() async {
    deviceId = await _sharedPrefsService.getDeviceId();
    captureInterval = await _sharedPrefsService.getIntervalCapture();

    showSettings = true;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    await _sharedPrefsService.setDeviceId(deviceId);
    await _sharedPrefsService.setCaptureInterval(captureInterval);
  }
}
