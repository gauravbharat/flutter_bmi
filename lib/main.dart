import 'package:bmi_calculator/screens/new_profile_page.dart';
import 'package:bmi_calculator/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'screens/input_page.dart';
import 'screens/results_page.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ProfileMode { createProfile, loadProfile, showHomePage }

void main() => runApp(BMICalculator());

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  ProfileMode currentMode = ProfileMode.createProfile;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    print('all init async calls goes here');

    _checkPageToLoad();
  }

  Future<void> _checkPageToLoad() async {
    final SharedPreferences prefs = await _prefs;

    if (prefs.containsKey(kProfileListKey)) {
      setState(() {
        currentMode = ProfileMode.loadProfile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Customize built-in themes with copyWith
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      // ThemeData(
      //   // colorScheme: ColorScheme.dark(),
      //   primaryColor: Color(0xFF0A0E21),
      //   scaffoldBackgroundColor: Color(0xFF0A0E21),
      //   accentColor: Colors.cyanAccent,
      //   textTheme: TextTheme(bodyText2: TextStyle(color: Color(0xFFFFFFFF))),
      // ),
      // home: InputPage(),
      // Using Named Routes instead of home page property
      initialRoute: currentMode == ProfileMode.createProfile
          ? kRouteNames['createProfile']
          : kRouteNames['home'],
      routes: {
        kRouteNames['createProfile']: (context) => NewProfilePage(),
        kRouteNames['home']: (context) => InputPage(),
        kRouteNames['results']: (context) => ResultsPage(),
        kRouteNames['settings']: (context) => SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

//TODO create user profiles for saved preferences, with security or fb-login?
