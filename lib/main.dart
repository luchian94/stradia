import 'package:flutter/material.dart';

import 'locator.dart';
import 'ui/screens/home/home.screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  runApp(
    MaterialApp(
      theme: ThemeData(),
      home: HomeScreen(),
    ),
  );
}
