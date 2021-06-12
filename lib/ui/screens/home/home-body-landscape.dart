import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'capture-counter.dart';
import 'home-camera-preview-landscape.dart';
import 'home-controls.dart';
import 'home-gps-speed.dart';
import 'home-gps-verify.dart';
import 'home-summary.dart';
import 'home.model.dart';

class HomeBodyLandscape extends ViewModelWidget<HomeModel> {
  HomeBodyLandscape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (model.isBusy) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Material(
                    elevation: 6.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (model.captureStatus == CaptureStatus.Capturing ||
                              model.captureStatus == CaptureStatus.Setup)
                            HomeCapturedCounter(),
                          HomeSummary(),
                          HomeGpsVerify(),
                        ],
                      ),
                    ),
                  ),
                ),
                if (model.captureStatus == CaptureStatus.Setup || model.captureStatus == CaptureStatus.Capturing)
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Material(
                        elevation: 6.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: CameraHomePreviewLandscape()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
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
