import 'package:get_it/get_it.dart';
import 'package:stradia/services/capture.service.dart';
import 'package:stradia/services/shared-prefs.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<CaptureService>(CaptureService());
  locator.registerSingleton<SharedPrefsService>(SharedPrefsService());
}
