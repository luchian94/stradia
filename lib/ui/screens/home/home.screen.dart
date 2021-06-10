import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/ui/screens/home/home-body-portrait.dart';
import 'package:stradia/ui/screens/home/home.model.dart';
import 'package:wakelock/wakelock.dart';

import '../settings/settings.screen.dart';
import 'home-body-landscape.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('STRADIA'),
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
                model.notifyListeners();
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
