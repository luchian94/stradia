import 'dart:async';

import 'package:camera/camera.dart';
import 'package:location/location.dart';
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

  bool? gpServiceEnabled;
  PermissionStatus? gpsPermissionStatus;

  int get capturedImages => _captureService.totalCaptures;
  bool get isCapturing => captureStatus == CaptureStatus.Capturing;
  bool get isSettingUp => captureStatus == CaptureStatus.Setup;
  bool get hasGpsPermission => gpsPermissionStatus == PermissionStatus.granted;
  bool get canGetLocation => gpServiceEnabled == true && hasGpsPermission;

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    final mainCamera = cameras.first;

    cameraController = CameraController(
      mainCamera,
      ResolutionPreset.medium,
    );

    await cameraController.initialize();
  }

  void prepareSession() async {
    _captureService.reset();
    showSummary = false;
    captureStatus = CaptureStatus.Setup;
    setBusy(true);
    await checkGpsServiceAndPermission();
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
    cameraController.dispose();
    if (_captureTimer != null) {
      _captureTimer!.cancel();
    }
    showSummary = true;
    _sessionId = null;
    notifyListeners();
  }

  Future<void> checkGpsServiceAndPermission() async {
    Location location = new Location();

    gpServiceEnabled = await location.serviceEnabled();
    if (gpServiceEnabled == false) {
      gpServiceEnabled = await location.requestService();
    }

    gpsPermissionStatus = await location.hasPermission();
    if (gpsPermissionStatus == PermissionStatus.denied) {
      gpsPermissionStatus = await location.requestPermission();
    }
  }

  void _takePictureAndSend() async {
    final image = await cameraController.takePicture();

    _captureService.capture(_sessionId, image.path);
  }

  String _generateSessionId() {
    var uuid = Uuid();
    return uuid.v4();
  }

}
