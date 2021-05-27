import 'package:get_it/get_it.dart';
import 'package:stradia/services/camera.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CameraService());
}
