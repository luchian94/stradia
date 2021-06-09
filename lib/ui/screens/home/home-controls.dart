import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.model.dart';

class HomeControls extends ViewModelWidget<HomeModel> {
  HomeControls({Key? key}) : super(key: key);

  Widget getButton(HomeModel model) {
    switch (model.captureStatus) {
      case CaptureStatus.Capturing:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: ValueKey("STOP BUTTON"),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 10),
              textStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
            ),
            onPressed: () => model.stopSession(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('STOP!'),
                Icon(Icons.stop, size: 30,),
              ],
            ),
          ),
        );
      case CaptureStatus.Setup:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: ValueKey("START BUTTON"),
            onPressed: model.canGetLocation ? () => model.startSession() : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10),
              textStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('PARTIAMO!'),
                Icon(Icons.drive_eta, size: 30,),
              ],
            ),
          ),
        );
      default:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: ValueKey("SETUP BUTTON"),
            onPressed: () => model.prepareSession(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10),
              textStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('INIZIA'),
                Icon(Icons.play_arrow, size: 30.0,),
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, HomeModel model) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: getButton(model),
    );
  }
}
