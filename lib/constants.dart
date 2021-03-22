import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Gender { male, female }
enum MeasurementSystem { metric, imperial }
enum ProfileMode { createProfile, loadProfile, showHomePage }

//Prefix constants with k
const Map<String, String> kRouteNames = {
  'home': '/home',
  'results': '/results',
  'settings': '/settings',
  'profile': '/',
  // 'loadProfiles': '/'
};

const double kBottomContainerHeight = 80.0;
const Color kActiveCardColour = Color(0xFF1D1E33);
const Color kInactiveCardColour = Color(0xFF111328);
const Color kBottomContainerColour = Color(0xFFEB1555);
const Color kOverlayColour = Color(0x29EB1555);

const double kIconSize = 40.0;
const double kSizedBoxHeight = 15.0;
const double kFontSize = 14.0;
const Color kIconColour = Color(0xFF8D8E98);
const TextStyle kStyleLabelText = TextStyle(
  fontSize: kFontSize,
  color: kIconColour,
);

const TextStyle kStyleLargeFontWt = TextStyle(
  fontSize: 30.0,
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

const int kMinAge = 10;
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

final TextInputFormatter kAllowOnlyInt = FilteringTextInputFormatter.allow(
  RegExp('[0-9]'),
);

final TextInputFormatter kAllowOnlyDoubles = FilteringTextInputFormatter.allow(
  RegExp(r'(^\d*\.?\d*)'),
);

const kProfileListKey = 'profileList';
const kGenderStorageKey = 'gender';
const kMeasurementStorageKey = 'measurement';
const kHeightStorageKey = 'height';
const kWeightStorageKey = 'weight';
const kAgeStorageKey = 'age';

const kCentimetreSuffix = 'cm';
const kFeetSuffix = 'ft';
const kPoundsSuffix = 'lb';
const kKiloSuffix = 'kg';

const kWeightConstant = 0.45359237;
const kHeightConstant = 30.48;

const kHelperTextHeightInitValue = 'cms = height in feet x $kHeightConstant';
final kHelperTextWeightInitValue =
    'kg = weight in lbs x ${kWeightConstant.toStringAsFixed(2)}';

final Map<String, Object> kDefaultUserPreferences = {
  kGenderStorageKey: Gender.female.index,
  kMeasurementStorageKey: MeasurementSystem.imperial.index,
  kHeightStorageKey: 6.0,
  kWeightStorageKey: 132.0,
  kAgeStorageKey: 18
};
