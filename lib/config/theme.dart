import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    appBarTheme: AppBarTheme(color: Colors.purple[400], centerTitle: true),
    primaryColor: Color(0xFFFDCB6E),
    scaffoldBackgroundColor: Color(0xFFF4E3E3),
    accentColor: Colors.purple[200],
    backgroundColor: Color(0xFFF4F4F4),
    fontFamily: 'Futura',
    textTheme: TextTheme(
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
  );
}
