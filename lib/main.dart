import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stradia/ui/screens/home.screen.dart';

import 'locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  setupLocator();

  runApp(
    MaterialApp(
      theme: ThemeData(),
      home: HomeScreen(),
    ),
  );
}
