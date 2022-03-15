import 'package:flutter/material.dart';

const primary = Color(0xFFf77080);

const cardColor = Colors.white;
const appBgColor = Color(0xFFF7F7F7);
const appBarColor = Color(0xFFF7F7F7);
const bottomBarColor = Colors.white;
const inActiveColor = Colors.grey;
const shadowColor = Colors.black87;
const textBoxColor = Colors.white;
const textColor = Color(0xFF333333);
const glassTextColor = Colors.white;
const labelColor = Color(0xFF8A8989);

const green = Color(0xFFB6CFB6);
const orange = Color(0xFFf5ba92);

ThemeData theme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(color: green, centerTitle: true),
    primaryColor: green,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: const Color(0xFFF4F4F4),
    fontFamily: 'Futura',
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Color(0xFF2F3542),
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
      headline2: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      headline3: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      headline4: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      headline5: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      headline6: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      bodyText1: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
      bodyText2: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.normal,
        fontSize: 10,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: green),
  );
}
