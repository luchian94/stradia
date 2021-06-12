import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.model.dart';

class HomeSummary extends ViewModelWidget<HomeModel> {
  HomeSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (model.showSummary) {
      int capturedImages = model.captureCount;
      return Text(
        capturedImages == 0 ? "0 immagini catturate. Riprova" : "Hai catturato $capturedImages immagini. Ottimo lavoro!",
        style: Theme.of(context).textTheme.headline5!.copyWith(
          color: capturedImages == 0 ? Colors.orangeAccent : Colors.green
        ),
        textAlign: TextAlign.center,
      );
    }
    if (model.captureStatus == CaptureStatus.Idle) {
      return Text(
        "Inizia una nuova sessione",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      );
    }
    return Container();
  }
}
