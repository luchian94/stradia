import 'dart:async';

import 'package:camera/camera.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/locator.dart';
import 'package:stradia/services/capture.service.dart';
import 'package:uuid/uuid.dart';

class HomeModel extends BaseViewModel {
  final _captureService = locator<CaptureService>();

  late CameraController cameraController;
  bool cameraReady = false;

  String? _sessionId;
  Timer? _captureTimer;

  get isCapturing => _captureTimer != null ? _captureTimer!.isActive : false;

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    final mainCamera = cameras.first;

    cameraController = CameraController(
      mainCamera,
      ResolutionPreset.medium,
    );

    await cameraController.initialize();
    cameraReady = true;
    notifyListeners();
  }

  void startSession() async {
    _sessionId = _generateSessionId();

    _captureTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      final image = await cameraController.takePicture();
      _captureService.capture(_sessionId, image.path);
    });
    notifyListeners();
  }

  void stopSession() {
    if (_captureTimer != null) {
      _captureTimer!.cancel();
    }
    _sessionId = null;
    notifyListeners();
  }

  String _generateSessionId() {
    var uuid = Uuid();
    return uuid.v4();
  }

}
