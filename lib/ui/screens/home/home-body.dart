import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'capture-counter/capture-counter.dart';
import 'home-camera-preview.dart';
import 'home-controls.dart';
import 'home-gps-verify.dart';
import 'home-summary.dart';
import 'home.model.dart';

class HomeBody extends ViewModelWidget<HomeModel> {
  HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (model.isBusy) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 6,
            right: 10,
            child: ElevatedButton(
              onPressed: () => model.notifyListeners(),
              child: Row(
                children: [
                  Text('Refresh Camera'),
                  Icon(Icons.refresh),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(model.captureStatus == CaptureStatus.Capturing)
                  HomeCapturedCounter(),
                HomeSummary(),
                HomeGpsVerify(),
                CameraHomePreview(),
              ],
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 10.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: HomeControls(),
            ),
          ),
        ],
      ),
    );
  }
}
