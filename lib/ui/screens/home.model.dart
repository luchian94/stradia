import 'package:camera/camera.dart';
import 'package:stacked/stacked.dart';

class HomeModel extends BaseViewModel {

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
  }

}
