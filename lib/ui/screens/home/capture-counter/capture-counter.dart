import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/ui/screens/home/capture-counter/capture-counter.model.dart';

class HomeCapturedCounter extends StatelessWidget {
  HomeCapturedCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CaptureCounterModel>.reactive(
      builder: (context, model, child) {
        var count = model.captureCount.toString();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Immagini catturate: $count',
            style: Theme.of(context).textTheme.headline4,
          ),
        );
      },
      viewModelBuilder: () => CaptureCounterModel(),
    );
  }
}
