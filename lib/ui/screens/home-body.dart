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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HomeControls(),
          HomeGpsVerify(),
          HomeSummary(),
          CameraHomePreview()
        ],
      ),
    );
  }
}
