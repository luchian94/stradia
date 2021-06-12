import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'capture-counter.dart';
import 'home-camera-preview-landscape.dart';
import 'home-camera-preview-portrait.dart';
import 'home-controls.dart';
import 'home-gps-speed.dart';
import 'home-gps-verify.dart';
import 'home-summary.dart';
import 'home.model.dart';

class HomeBodyPortrait extends ViewModelWidget<HomeModel> {
  HomeBodyPortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (model.isBusy) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Material(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (model.captureStatus == CaptureStatus.Capturing ||
                        model.captureStatus == CaptureStatus.Setup)
                      HomeCapturedCounter(),
                    HomeSummary(),
                    HomeGpsVerify(),
                    if (model.captureStatus == CaptureStatus.Capturing ||
                        model.captureStatus == CaptureStatus.Setup)
                    Expanded(child: CameraHomePreviewPortrait()),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Expanded(child: HomeControls()),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: HomeGpsSpeed(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
