import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'settings.model.dart';

class SettingsBody extends HookViewModelWidget<SettingsModel> {
  SettingsBody({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, SettingsModel model) {
    var captureInterval = useTextEditingController();
    var deviceId = useTextEditingController();

    if (model.showSettings != true) {
      return Center(child: CircularProgressIndicator());
    }

    deviceId.text = model.deviceId;
    captureInterval.text = model.captureInterval.toString();

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          TextFormField(
            controller: deviceId,
            onChanged: (value) => model.deviceId = value,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Device ID",
              hintText: "Inserisci id del dispositivo",
            ),
          ),
          TextFormField(
            controller: captureInterval,
            onChanged: (value) => model.captureInterval = int.parse(value),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              labelText: "Intervallo di cattura immagini (ms)",
            ),
          )
        ],
      ),
    );
  }
}
