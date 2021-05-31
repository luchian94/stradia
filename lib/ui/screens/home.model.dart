import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/locator.dart';
import 'package:stradia/services/capture.service.dart';
import 'package:uuid/uuid.dart';

enum CaptureStatus {
  Idle,
  Capturing,
  Setup
}

class HomeModel extends BaseViewModel {
  final _captureService = locator<CaptureService>();

  late CameraController cameraController;
  CaptureStatus captureStatus = CaptureStatus.Idle;

  String? _sessionId;
  Timer? _captureTimer;
  bool showSummary = false;

  get isCapturing => captureStatus == CaptureStatus.Capturing;
  get capturedImages => _captureService.totalCaptures;

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    final mainCamera = cameras.first;

    cameraController = CameraController(
      mainCamera,
      ResolutionPreset.veryHigh,
    );

    await cameraController.initialize();
  }

  void prepareSession() async {
    _captureService.reset();
    showSummary = false;
    captureStatus = CaptureStatus.Setup;
    setBusy(true);
    await setupCamera();
    setBusy(false);
  }

  void startSession() async {
    _sessionId = _generateSessionId();

    _captureTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _takePictureAndSend();
    });
    captureStatus = CaptureStatus.Capturing;
    notifyListeners();
  }

  void stopSession() {
    captureStatus = CaptureStatus.Idle;
    if (_captureTimer != null) {
      _captureTimer!.cancel();
    }
    showSummary = true;
    _sessionId = null;
    notifyListeners();
  }

  void _takePictureAndSend() async {
    final image = await cameraController.takePicture();
    var imgBytes = await image.readAsBytes();
    String base64Image = base64Encode(imgBytes);

    _captureService.capture(_sessionId, base64Image);
  }

  String _generateSessionId() {
    var uuid = Uuid();
    return uuid.v4();
  }

}
