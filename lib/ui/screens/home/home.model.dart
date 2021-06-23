import 'dart:async';
import 'dart:io';

import 'package:ai_way/locator.dart';
import 'package:ai_way/services/capture.service.dart';
import 'package:ai_way/services/shared-prefs.service.dart';
import 'package:ai_way/utils/image-utils.dart';
import 'package:camera/camera.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

enum CaptureStatus {
  Idle,
  Capturing,
  Setup
}

class HomeModel extends ReactiveViewModel {
  final _captureService = locator<CaptureService>();
  SharedPrefsService _sharedPrefsService = locator<SharedPrefsService>();

  late CameraController cameraController;
  CaptureStatus captureStatus = CaptureStatus.Idle;

  String? _sessionId;
  Timer? _captureTimer;
  bool showSummary = false;
  bool capturingImageForCrop = false;

  late bool gpServiceEnabled;
  PermissionStatus? gpsPermissionStatus;

  int get captureCount => _captureService.captureCount;
  int get failedCapturesCount => _captureService.failedCapturesCount;
  double? get currentSpeed => _captureService.currentSpeed;
  bool get isCapturing => captureStatus == CaptureStatus.Capturing;
  bool get isSettingUp => captureStatus == CaptureStatus.Setup;
  bool get hasGpsPermission => gpsPermissionStatus == PermissionStatus.granted;
  bool get canGetLocation => gpServiceEnabled == true && hasGpsPermission;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_captureService];

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    final mainCamera = cameras.first;

    cameraController = CameraController(
      mainCamera,
      ResolutionPreset.high,
      enableAudio: false
    );

    await cameraController.initialize();
    cameraController.setFlashMode(FlashMode.off);
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
    if (_captureTimer != null) {
      _captureTimer!.cancel();
    }
    _sessionId = _generateSessionId();

    int captureInterval = await _sharedPrefsService.getIntervalCapture();
    _captureTimer = Timer.periodic(Duration(milliseconds: captureInterval), (timer) {
      _takePictureAndSend();
    });
    captureStatus = CaptureStatus.Capturing;
    notifyListeners();
  }

  void stopSession() {
    captureStatus = CaptureStatus.Idle;
    cameraController.dispose();
    _captureService.cancelLocationSubscription();
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
      if (!gpServiceEnabled) {
        return null;
      }
    }

    gpsPermissionStatus = await location.hasPermission();
    if (gpsPermissionStatus == PermissionStatus.denied) {
      gpsPermissionStatus = await location.requestPermission();
      if (gpsPermissionStatus != PermissionStatus.granted) {
        return null;
      }
    }

    _captureService.listenToLocationChange();
  }

  Future<File?> takeCameraPicture() async {
    if (cameraController.value.isTakingPicture) {
      return null;
    }
    final image = await cameraController.takePicture();
    await ImageProcessor.fixImageRotation(image.path);
    return File(image.path);
  }

  Future<File?> getPictureFoCrop() async {
    capturingImageForCrop = true;
    notifyListeners();
    var picture = await takeCameraPicture();
    capturingImageForCrop = false;
    notifyListeners();
    return picture;
  }

  Future<void> _takePictureAndSend() async {
    if (_captureService.currentSpeed != null && _captureService.currentSpeed! >= 5.0) {
      final image = await takeCameraPicture();
      if (image != null) {
        _captureService.capture(_sessionId, image.path);
      }
    }
  }

  String _generateSessionId() {
    var uuid = Uuid();
    return uuid.v4();
  }

}
