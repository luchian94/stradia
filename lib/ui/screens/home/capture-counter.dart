import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.model.dart';

class HomeCapturedCounter extends ViewModelWidget<HomeModel> {
  HomeCapturedCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeModel model) {
    var count = model.captureCount.toString();
    var capturesInQueue = model.failedCapturesCount.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            'Immagini catturate: $count',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              'Immagini in coda: $capturesInQueue',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.orangeAccent
              ),
            ),
          ),
        ],
      ),
    );
  }
}
