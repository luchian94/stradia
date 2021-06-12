import 'package:get_it/get_it.dart';

import 'services/capture.service.dart';
import 'services/shared-prefs.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<SharedPrefsService>(SharedPrefsService());
  locator.registerSingleton<CaptureService>(CaptureService());
}
