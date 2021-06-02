import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/ui/screens/home/home.model.dart';

class CameraHomePreview extends ViewModelWidget<HomeModel> {
  CameraHomePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if(model.captureStatus == CaptureStatus.Idle) {
      return Container();
    }

    return Material(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRect(
          child: Container(
            width: 300,
            height: 300,
            child: Center(
              child: CameraPreview(model.cameraController),
            ),
          ),
        ),
      ),
    );
  }
}
