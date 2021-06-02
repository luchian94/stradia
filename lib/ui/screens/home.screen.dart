import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/ui/screens/home.model.dart';

import 'home-body.dart';
import 'settings/settings.screen.dart';

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
            return HomeBody();
          },
          viewModelBuilder: () => HomeModel(),
        ),
      ),
    );
  }
}
