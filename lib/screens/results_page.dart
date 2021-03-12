import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:bmi_calculator/components/reusable_card.dart';
import '../components/bottom_button.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> _arguments =
        ModalRoute.of(context).settings.arguments;
    final _actionColour = _arguments['actionColour'];
    final _actionTextColour = _arguments['actionTextColour'];
    final Map<String, String> _bmiResult = _arguments['bmiResult'];

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Your Result',
                // textAlign: TextAlign.center,
                style: kTitleTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _bmiResult['result'].toUpperCase(),
                    style: kResultTextStyle,
                  ),
                  Text(
                    _bmiResult['bmi'],
                    style: kBmiTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      _bmiResult['interpretation'],
                      textAlign: TextAlign.center,
                      style: kBodyTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      'BMI results calculation reference: https://en.wikipedia.org/wiki/Body_mass_index',
                      textAlign: TextAlign.center,
                      style: kStyleLabelText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomButton(
            colour: _actionColour,
            buttonTextColour: _actionTextColour,
            buttonText: 'RE-CALCULATE',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
