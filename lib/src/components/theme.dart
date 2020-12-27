import 'package:flutter/material.dart';

Color primaryColor = Color.fromARGB(255, 166, 121, 91);
Color accentColor = Color.fromARGB(255, 200, 173, 125);
Color canvasColor = Color.fromARGB(255, 245, 245, 245);
ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  accentColor: accentColor,
  canvasColor: canvasColor,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: canvasColor,
  accentColor: primaryColor,
  canvasColor: accentColor,
);
