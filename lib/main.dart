import 'package:flutter/material.dart';
import 'screens/input_page.dart';
import 'screens/results_page.dart';
import 'constants.dart';

void main() => runApp(BMICalculator());

class BMICalculator extends StatelessWidget {
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
      initialRoute: kRouteNames['home'],
      routes: {
        kRouteNames['home']: (context) => InputPage(),
        kRouteNames['results']: (context) => ResultsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
