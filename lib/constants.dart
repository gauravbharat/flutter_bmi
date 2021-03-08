import 'package:flutter/material.dart';

//Prefix constants with k
const Map<String, String> kRouteNames = {'home': '/', 'results': '/results'};

const double kBottomContainerHeight = 80.0;
const Color kActiveCardColour = Color(0xFF1D1E33);
const Color kInactiveCardColour = Color(0xFF111328);
const Color kBottomContainerColour = Color(0xFFEB1555);
const Color kOverlayColour = Color(0x29EB1555);

const double kIconSize = 80.0;
const double kSizedBoxHeight = 15.0;
const double kFontSize = 18.0;
const Color kIconColour = Color(0xFF8D8E98);
const TextStyle kStyleLabelText = TextStyle(
  fontSize: kFontSize,
  color: kIconColour,
);

const TextStyle kStyleLargeFontWt = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

const TextStyle kStyleLargeButton = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const double kSliderMin = 3.0;
const double kSliderMax = 8.0;

const double kMinWeight = 66.14;
const double kMaxWeight = 330.70;

const int kMinAge = 18;
const int kMaxAge = 90;

const kTitleTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const kBmiTextStyle = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
);

const kBodyTextStyle = TextStyle(fontSize: 22.0);