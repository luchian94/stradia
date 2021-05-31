import 'package:get_it/get_it.dart';
import 'package:stradia/services/capture.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<CaptureService>(CaptureService());
}
