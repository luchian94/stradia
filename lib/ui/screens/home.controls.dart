import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.model.dart';

class HomeControls extends ViewModelWidget<HomeModel> {
  HomeControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: model.isCapturing
          ? ElevatedButton(
              key: ValueKey("STOP BUTTON"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () => model.stopSession(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('START'),
                  Icon(Icons.stop),
                ],
              ),
            )
          : ElevatedButton(
            key: ValueKey("START BUTTON"),
            onPressed: () => model.startSession(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('START'),
                Icon(Icons.play_arrow),
              ],
            ),
          ),
    );
  }
}
