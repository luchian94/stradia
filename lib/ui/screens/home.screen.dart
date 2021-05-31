import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stradia/ui/screens/home.model.dart';

import 'home.camera.preview.dart';
import 'home.controls.dart';

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
                onPressed: () {},
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
              return Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeControls(),
                    CameraHomePreview()
                  ],
                ),
              );
            },
            onModelReady: (viewModel) => viewModel.setupCamera(),
            viewModelBuilder: () => HomeModel()),
      ),
    );
  }
}
