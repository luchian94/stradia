import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'settings.model.dart';
import 'settings_body.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsModel>.nonReactive(
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('SETTINGS'),
              centerTitle: true,
              automaticallyImplyLeading: true,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: IconButton(
                    onPressed: () async {
                      await model.saveSettings();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.save,
                      size: 34.0,
                    ),
                  ),
                )
              ],
            ),
            body: SettingsBody(),
          ),
        );
      },
      viewModelBuilder: () => SettingsModel(),
      onModelReady: (model) => model.getSettings(),
    );
  }
}
