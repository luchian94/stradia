import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 6,
          right: 10,
          child: ElevatedButton(
            onPressed: () => model.notifyListeners(),
            child: Icon(Icons.refresh),
          ),
        ),
        HomeGpsVerify(),
        HomeSummary(),
        CameraHomePreview(),
        Positioned(
          bottom: 10.0,
          child: HomeControls(),
        ),
      ],
    );
  }
}
