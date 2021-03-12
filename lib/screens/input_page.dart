import 'dart:async';

import 'package:bmi_calculator/calculator_brain.dart';
import 'package:bmi_calculator/components/bottom_button.dart';
import 'package:bmi_calculator/components/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../components/icon_content.dart';
import '../components/reusable_card.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Gender _selectedGender = Gender.female;
  MeasurementSystem _selectedMeasurement = MeasurementSystem.imperial;
  String _selectedHeightMeasurement = 'ft';
  String _selectedWeightMeasurement = 'lb';
  double _height = 6.0;
  double _weight = 132.0;
  int _age = 18;
  bool _startWeightCounter = false;
  bool _startAgeCounter = false;
  List<bool> _isSelected = [false, true];
  Timer _timer;
  Color _actionColour = kBottomContainerColour;
  Color _actionTextColour = Colors.white;

  @override
  void initState() {
    super.initState();
    print('all init async calls goes here');
    _initUserPreferences();
  }

  Future<void> _initUserPreferences() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _selectedGender = prefs.containsKey(kGenderStorageKey)
          ? Gender.values[prefs.getInt(kGenderStorageKey)]
          : _selectedGender;

      _selectedMeasurement = prefs.containsKey(kMeasurementStorageKey)
          ? MeasurementSystem.values[prefs.getInt(kMeasurementStorageKey)]
          : _selectedMeasurement;

      _height = prefs.containsKey(kHeightStorageKey)
          ? prefs.getDouble(kHeightStorageKey)
          : _height;
      _weight = prefs.containsKey(kWeightStorageKey)
          ? prefs.getInt(kWeightStorageKey).toDouble()
          : _weight;
      _age = prefs.containsKey(kAgeStorageKey)
          ? prefs.getInt(kAgeStorageKey)
          : _age;
    });

    _setGenderSpecificProps();
    _setMeasurementSpecificProps();
  }

  void _setGenderSpecificProps() {
    setState(() {
      if (_selectedGender == Gender.male) {
        _actionColour = Colors.cyanAccent;
        _actionTextColour = Colors.blueGrey;
      } else {
        _actionColour = kBottomContainerColour;
        _actionTextColour = Colors.white;
      }
    });
  }

  void _setMeasurementSpecificProps() {
    if (_selectedMeasurement == MeasurementSystem.metric) {
      _isSelected = [true, false];
      _selectedHeightMeasurement = 'cm';
      _selectedWeightMeasurement = 'kg';
    } else {
      _isSelected = [false, true];
      _selectedHeightMeasurement = 'ft';
      _selectedWeightMeasurement = 'lb';
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    print('all cleanup code goes here before the widget is destroyed');
  }

  Color _getGenderCardColour(bool condition) {
    return condition ? kActiveCardColour : kInactiveCardColour;
  }

  void _cancelTimer() {
    if (_timer != null) _timer.cancel();
  }

  void _incrementWeightCounter({bool isLongPress: false}) {
    if (isLongPress) {
      _autoSetWeightCounter(isIncrementing: true);
    } else {
      _cancelTimer();
      setState(() {
        _startWeightCounter = false;
        if (_weight < kMaxWeight) _weight++;
      });
    }
  }

  void _decrementWeightCounter({bool isLongPress: false}) {
    if (isLongPress) {
      _autoSetWeightCounter();
    } else {
      _cancelTimer();
      setState(() {
        _startWeightCounter = false;
        if (_weight > kMinWeight) _weight--;
      });
    }
  }

  void _autoSetWeightCounter({bool isIncrementing: false}) {
    _startWeightCounter = !_startWeightCounter;

    if (_startWeightCounter) {
      _timer = Timer.periodic(Duration(milliseconds: 500), (t) {
        setState(() {
          if (isIncrementing && _weight < kMaxWeight) _weight++;
          if (!isIncrementing && _weight > kMinWeight) _weight--;
        });
        if (_weight == kMaxWeight || _weight == kMinWeight) _cancelTimer();
      });
    } else {
      _cancelTimer();
    }
  }

  void _incrementAgeCounter({bool isLongPress: false}) {
    if (isLongPress) {
      _autoSetAgeCounter(isIncrementing: true);
    } else {
      _cancelTimer();
      setState(() {
        _startAgeCounter = false;
        if (_age < kMaxAge) _age++;
      });
    }
  }

  void _decrementAgeCounter({bool isLongPress: false}) {
    if (isLongPress) {
      _autoSetAgeCounter();
    } else {
      _cancelTimer();
      setState(() {
        _startAgeCounter = false;
        if (_age > kMinAge) _age--;
      });
    }
  }

  void _autoSetAgeCounter({bool isIncrementing: false}) {
    _startAgeCounter = !_startAgeCounter;

    if (_startAgeCounter) {
      _timer = Timer.periodic(Duration(milliseconds: 500), (t) {
        setState(() {
          if (isIncrementing && _age < kMaxAge) _age++;
          if (!isIncrementing && _age > kMinAge) _age--;
        });
        if (_age == kMaxAge || _age == kMinAge) _cancelTimer();
      });
    } else {
      _cancelTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.cog),
            splashRadius: 21.0,
            onPressed: () async {
              try {
                final settings =
                    await Navigator.pushNamed(context, kRouteNames['settings'])
                        as Map<String, dynamic>;

                print(settings);
                // apply settings only when save is pressed, and not cancel or back button
                if (settings != null) {
                  setState(() {
                    _selectedGender = settings[kGenderStorageKey];
                    _selectedMeasurement = settings[kMeasurementStorageKey];
                    _height = settings[kHeightStorageKey];
                    _weight = settings[kWeightStorageKey];
                    _age = settings[kAgeStorageKey] ?? _age;
                  });

                  _setGenderSpecificProps();
                  _setMeasurementSpecificProps();
                }
              } catch (e) {
                //  do nothing
                print('exception in future on return from settings $e');
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _genderCards(),
          _measurementToggle(),
          Expanded(
            child: _heightCard(),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                _weightCard(),
                _ageCard(),
              ],
            ),
          ),
          BottomButton(
            colour: _actionColour,
            buttonText: 'CALCULATE',
            buttonTextColour: _actionTextColour,
            onTap: () {
              CalculatorBrain calc =
                  CalculatorBrain(height: _height, weight: _weight);

              Navigator.pushNamed(context, kRouteNames['results'],
                  arguments: <String, Object>{
                    'actionColour': _actionColour,
                    'actionTextColour': _actionTextColour,
                    'bmiResult': calc.getResult(),
                  });
            },
          ),
        ],
      ),
      // floatingActionButton: Theme(
      //   data: ThemeData(accentColor: Colors.cyanAccent),
      //   child: FloatingActionButton(
      //     child: Icon(Icons.add),
      //   ),
      // ),
    );
  }

  Widget _genderCards() {
    return Expanded(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ReusableCard(
              onUserTap: () {
                setState(() {
                  _selectedGender = Gender.male;
                });
                _setGenderSpecificProps();
              },
              colour: _getGenderCardColour(_selectedGender == Gender.male),
              cardChild: IconButtonsGender(
                buttonIcon: FontAwesomeIcons.mars,
                label: 'MALE',
              ),
            ),
          ),
          Expanded(
            child: ReusableCard(
              onUserTap: () {
                setState(() {
                  _selectedGender = Gender.female;
                });
                _setGenderSpecificProps();
              },
              colour: _getGenderCardColour(_selectedGender == Gender.female),
              cardChild: IconButtonsGender(
                buttonIcon: FontAwesomeIcons.venus,
                label: 'FEMALE',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _measurementToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          constraints: BoxConstraints.expand(
            width: MediaQuery.of(context).size.width / 3 - 2,
          ),
          selectedColor: Colors.white,
          fillColor: kActiveCardColour,
          color: kIconColour,
          borderRadius: BorderRadius.circular(10.0),
          textStyle: TextStyle(
            fontSize: 18.0,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Text('Metric'),
            ),
            Text('Imperial')
          ],
          isSelected: _isSelected,
          onPressed: (index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < _isSelected.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  _isSelected[buttonIndex] = true;
                } else {
                  _isSelected[buttonIndex] = false;
                }
              }

              if (_isSelected[0] == true) {
                _selectedMeasurement = MeasurementSystem.metric;
                _selectedHeightMeasurement = 'cm';
                _selectedWeightMeasurement = 'kg';
              } else {
                _selectedMeasurement = MeasurementSystem.imperial;
                _selectedHeightMeasurement = 'ft';
                _selectedWeightMeasurement = 'lb';
              }
            });
          },
        ),
      ],
    );
  }

  Widget _heightCard() {
    return ReusableCard(
      colour: kActiveCardColour,
      cardChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(right: 8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       ToggleButtons(
          //         selectedColor: Colors.white,
          //         color: kIconColour,
          //         borderRadius: BorderRadius.circular(10.0),
          //         textStyle: TextStyle(
          //           fontSize: 18.0,
          //         ),
          //         children: [Text('cm'), Text('ft')],
          //         isSelected: _isSelected,
          //         onPressed: (index) {
          //           setState(() {
          //             for (int buttonIndex = 0;
          //                 buttonIndex < _isSelected.length;
          //                 buttonIndex++) {
          //               if (buttonIndex == index) {
          //                 _isSelected[buttonIndex] = true;
          //               } else {
          //                 _isSelected[buttonIndex] = false;
          //               }
          //             }
          //
          //             if (_isSelected[0] == true) {
          //               _selectedMeasurement = MeasurementSystem.metric;
          //               _selectedMeasurementText = 'cm';
          //             } else {
          //               _selectedMeasurement =
          //                   MeasurementSystem.imperial;
          //               _selectedMeasurementText = 'ft';
          //             }
          //           });
          //         },
          //       )
          //     ],
          //   ),
          // ),
          Text(
            'HEIGHT',
            style: kStyleLabelText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                _selectedMeasurement == MeasurementSystem.imperial
                    ? _height.toStringAsFixed(1)
                    : (_height * 30.48).toStringAsFixed(0),
                style: kStyleLargeFontWt,
              ),
              Text(
                _selectedHeightMeasurement,
                style: kStyleLabelText,
              ),
            ],
          ),
          SliderTheme(
            // Pass a copy of the current app context using SliderTheme.of(context)
            data: SliderTheme.of(context).copyWith(
              inactiveTrackColor: kInactiveCardColour,
              activeTrackColor: _actionColour,
              thumbColor: _actionColour,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: 30.0,
              ),
              overlayColor: _selectedGender == Gender.female
                  ? kOverlayColour
                  : Color(0x2918FFFF),
            ),
            child: Slider(
              min: kSliderMin,
              max: kSliderMax,
              value: _height,
              // label: '$height',
              onChanged: (newHeight) => setState(() => _height = newHeight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weightCard() {
    return Expanded(
      child: ReusableCard(
        colour: kActiveCardColour,
        cardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WEIGHT',
              style: kStyleLabelText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  _selectedMeasurement == MeasurementSystem.imperial
                      ? _weight.round().toStringAsFixed(0)
                      // : (_weight / 2.205).toStringAsFixed(1),
                      : (_weight * 0.45359237).toStringAsFixed(0),
                  style: kStyleLargeFontWt,
                ),
                Text(
                  _selectedWeightMeasurement,
                  style: kStyleLabelText,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundIconButton(
                  onLongPressed: () =>
                      _decrementWeightCounter(isLongPress: true),
                  onPressed: _decrementWeightCounter,
                  fillColor: _selectedGender == Gender.female
                      ? kOverlayColour
                      : Color(0x2918FFFF),
                  buttonIcon: Icon(
                    FontAwesomeIcons.minus,
                    color: _weight.round() == kMinWeight.round()
                        ? kInactiveCardColour
                        : Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                RoundIconButton(
                  onLongPressed: () =>
                      _incrementWeightCounter(isLongPress: true),
                  onPressed: _incrementWeightCounter,
                  fillColor: _selectedGender == Gender.female
                      ? kOverlayColour
                      : Color(0x2918FFFF),
                  buttonIcon: Icon(
                    FontAwesomeIcons.plus,
                    color: _weight.round() == kMaxWeight.round()
                        ? kInactiveCardColour
                        : Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _ageCard() {
    return Expanded(
      child: ReusableCard(
        colour: kActiveCardColour,
        cardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'AGE',
              style: kStyleLabelText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  _age.toString(),
                  style: kStyleLargeFontWt,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundIconButton(
                  onLongPressed: () => _decrementAgeCounter(isLongPress: true),
                  onPressed: _decrementAgeCounter,
                  fillColor: _selectedGender == Gender.female
                      ? kOverlayColour
                      : Color(0x2918FFFF),
                  buttonIcon: Icon(
                    FontAwesomeIcons.minus,
                    color: _age == kMinAge ? kInactiveCardColour : Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                RoundIconButton(
                  onLongPressed: () => _incrementAgeCounter(isLongPress: true),
                  onPressed: _incrementAgeCounter,
                  fillColor: _selectedGender == Gender.female
                      ? kOverlayColour
                      : Color(0x2918FFFF),
                  buttonIcon: Icon(
                    FontAwesomeIcons.plus,
                    color: _age == kMaxAge ? kInactiveCardColour : Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
