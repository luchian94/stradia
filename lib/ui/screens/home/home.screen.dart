import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wakelock/wakelock.dart';

import '../settings/settings.screen.dart';
import 'home-body-landscape.dart';
import 'home-body-portrait.dart';
import 'home.model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('AI WAY'),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                icon: Icon(
                  Icons.settings,
                  size: 34.0,
                ),
              ),
            )
          ],
        ),
        body: ViewModelBuilder<HomeModel>.nonReactive(
          builder: (context, model, child) {
            return OrientationBuilder(
              builder: (context, orientation){
                if(orientation == Orientation.portrait){
                  return HomeBodyPortrait();
                }else{
                  return HomeBodyLandscape();
                }
              },
            );
          },
          onModelReady: (model) => Wakelock.enable(),
          viewModelBuilder: () => HomeModel(),
        ),
      ),
    );
  }
}
