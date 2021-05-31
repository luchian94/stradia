import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.model.dart';

class HomeControls extends ViewModelWidget<HomeModel> {
  HomeControls({Key? key}) : super(key: key);

  Widget getButton(HomeModel model) {
    switch(model.captureStatus) {
      case CaptureStatus.Capturing:
        return ElevatedButton(
          key: ValueKey("STOP BUTTON"),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () => model.stopSession(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('STOP!'),
              Icon(Icons.stop),
            ],
          ),
        );
      case CaptureStatus.Setup:
        return ElevatedButton(
          key: ValueKey("START BUTTON"),
          onPressed: () => model.startSession(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('PARTIAMO!'),
              Icon(Icons.play_arrow),
            ],
          ),
        );
      default:
        return ElevatedButton(
          key: ValueKey("SETUP BUTTON"),
          onPressed: () => model.prepareSession(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('INIZIA'),
              Icon(Icons.play_arrow),
            ],
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
