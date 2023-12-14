import 'package:flutter/material.dart';
import 'package:jogo_pokedex/src/home.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.light(),
      home: const Home(),
    );
  }
}
