import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/ui/screens/home.model.dart';

class CameraHomePreview extends ViewModelWidget<HomeModel> {
  CameraHomePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (!model.cameraReady) {
      return CircularProgressIndicator();
    }
    return Column(
      children: [
        Text(
          "Anteprima",
          style: Theme.of(context).textTheme.headline5,
        ),
        Container(
          width: 300,
          height: 300,
          child: CameraPreview(model.cameraController),
        ),
      ],
    );
  }
}
