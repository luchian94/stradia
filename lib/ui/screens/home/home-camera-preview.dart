import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/ui/screens/crop-image/crop-image.screen.dart';
import 'package:stradia/ui/screens/home/home.model.dart';

class CameraHomePreview extends ViewModelWidget<HomeModel> {
  CameraHomePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (model.captureStatus == CaptureStatus.Idle) {
      return Container();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ClipRect(
            child: Container(
              width: 400,
              height: 400,
              child: Center(
                child: CameraPreview(model.cameraController),
              ),
            ),
          ),
        ),
        if (model.capturingImageForCrop) CircularProgressIndicator(),
        if (!model.capturingImageForCrop)
          ElevatedButton(
            onPressed: () async {
              var picture = await model.getPictureFoCrop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CropImageScreen(image: picture),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.orangeAccent,
              textStyle:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Imposta crop  '),
                Icon(Icons.crop),
              ],
            ),
          ),
      ],
    );
  }
}
