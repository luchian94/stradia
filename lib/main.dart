import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'locator.dart';
import 'ui/screens/home/home.screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  runApp(AiWayApp());
}

class AiWayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff498299),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: Color(0xff498299)),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
