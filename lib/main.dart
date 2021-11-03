import 'dart:async';

import 'package:ai_way/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'locator.dart';
import 'ui/screens/home/home.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  AuthenticationService _authenticationService = locator<AuthenticationService>();
  await _authenticationService.getAuthenticationToken();
  const refreshPeriod = Duration(minutes: 58);
  Timer.periodic(refreshPeriod, (Timer t) => _authenticationService.getAuthenticationToken());
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
