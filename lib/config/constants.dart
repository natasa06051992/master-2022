import 'package:flutter/material.dart';

class Constants {
  static List<String> get services =>
      ['Čišćenje', 'Majstor', 'Vodoinstalater', 'Drugo'];
  static List<String> get locations => ['Novi Sad', 'Beograd', 'Niš', 'Vršac'];
  static List<String> get role => ['Majstor', 'Mušterija'];
  static List<String> get sortBy => [
        'Jeftinija početna cena',
        'Skuplja početna cena',
        'Najveća ocena',
        'Najpopularniji'
      ];
  static const String poppins = "Poppins";
  static const String openSans = "OpenSans";

  static const String next = "Dalje";
  static const String sliderHeading1 = "Nađi majstora!";
  static const String sliderHeading2 = "Lako za korišćenje!";
  static const String sliderDesc1 =
      "Čistačice, majstore, vodoinstalatere, molere i mnoge druge.";
  static const String sliderDesc2 =
      "Sortiraj majstore po početnoj ceni, najpopularnije ili sa najvećom ocenom.";
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
