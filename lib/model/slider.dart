import 'package:flutter_master/config/constants.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {required this.sliderImageUrl,
      required this.sliderHeading,
      required this.sliderSubHeading});
}

final sliderArrayList = [
  Slider(
      sliderImageUrl: 'assets/handymenOnBoarding.png',
      sliderHeading: Constants.sliderHeading1,
      sliderSubHeading: Constants.sliderDesc1),
  Slider(
      sliderImageUrl: 'assets/handymen2.png',
      sliderHeading: Constants.sliderHeading2,
      sliderSubHeading: Constants.sliderDesc2),
];
