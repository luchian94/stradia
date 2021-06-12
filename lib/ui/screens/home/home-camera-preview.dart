import 'package:ai_way/ui/screens/crop-image/crop-image.screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.model.dart';

class CameraHomePreview extends ViewModelWidget<HomeModel> {
  CameraHomePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (model.captureStatus == CaptureStatus.Idle) {
      return Container();
    }

    return Column(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Center(child: CameraPreview(model.cameraController)),
        )),
        if (model.capturingImageForCrop) CircularProgressIndicator(),
        if (!model.capturingImageForCrop &&
            model.captureStatus == CaptureStatus.Setup)
          ElevatedButton(
            onPressed: () async {
              var picture = await model.getPictureFoCrop();
              if (picture != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CropImageScreen(image: picture),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.orangeAccent,
              textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Seleziona l\'area  '),
                Icon(Icons.crop),
              ],
            ),
          ),
      ],
    );
  }
}
