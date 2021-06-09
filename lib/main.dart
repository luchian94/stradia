import 'package:flutter/material.dart';
import 'package:stradia/ui/screens/home/home.screen.dart';

import 'locator.dart';

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
