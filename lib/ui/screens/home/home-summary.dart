import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/ui/screens/home/home.model.dart';

class HomeSummary extends ViewModelWidget<HomeModel> {
  HomeSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    if (model.showSummary) {
      int capturedImages = model.capturedImages;
      return Text(
        "Hai catturato $capturedImages immagini. Ottimo lavoro!",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      );
    }
    if (model.captureStatus == CaptureStatus.Idle) {
      return Text(
        "Premi INIZIA per una nuova sessione",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      );
    }
    return Container();
  }
}
