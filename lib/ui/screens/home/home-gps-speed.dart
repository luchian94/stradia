import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.model.dart';

class HomeGpsSpeed extends ViewModelWidget<HomeModel> {
  HomeGpsSpeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    var currentSpeed = model.currentSpeed != null ? model.currentSpeed!.round() : null;
    String speed = currentSpeed != null ? currentSpeed.toString() : '--';

    var textStyle1 = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w900,
        color: currentSpeed != null && currentSpeed < 5 ? Colors.redAccent : Colors.green
    );
    var textStyle = TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w900,
        color: currentSpeed != null && currentSpeed < 5 ? Colors.redAccent : Colors.green
    );

    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 6.0,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(speed, style: textStyle1),
                  Text(
                    "km/h",
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
