import 'package:flutter/foundation.dart';
import 'dart:math';

class CalculatorBrain {
  const CalculatorBrain({@required this.height, @required this.weight});
  final double height;
  final double weight;

  double _calculateBMI() {
    final heightInInches = height * 12;
    double bmi = (weight / pow(heightInInches, 2)) * 703;

    // print('heightInInches: $heightInInches, weight $weight, bmi $bmi');

    return bmi;
  }

  Map<String, String> getResult() {
    final bmi = _calculateBMI();
    String result;
    String interpretation;

    if (bmi >= 25.0) {
      result = 'Overweight';
      interpretation = 'You have a higher than normal body weight.';
    } else if (bmi > 18.5) {
      result = 'Normal';
      interpretation = 'You have a normal body weight. Good job!';
    } else {
      result = 'Underweight';
      interpretation = 'You have a lower than normal body weight.';
    }

    return {
      'bmi': bmi.toStringAsFixed(1),
      'result': result,
      'interpretation': interpretation
    };
  }
}
