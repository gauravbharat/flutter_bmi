import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../constants.dart';
import 'package:bmi_calculator/components/reusable_card.dart';
import 'package:bmi_calculator/components/reusable_text_container.dart';
import 'package:bmi_calculator/components/show_snackbar.dart';

// class CustomRangeTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     // if(newValue.text == '')
//     //   return TextEditingValue();
//     // else if(int.parse(newValue.text) < 1)
//     //   return TextEditingValue().copyWith(text: '1');
//     //
//     // return int.parse(newValue.text) > 20 ? TextEditingValue().copyWith(text: '20') : newValue;
//     print('oldvalue ${oldValue.text} newvalue ${newValue.text}');
//     return newValue;
//   }
// }

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Gender _selectedGender;
  MeasurementSystem _selectedMeasurementSystem;
  String _userSavedHeight;
  String _userSavedWeight;
  String _userSavedAge;
  String _currentProfileName;
  Map<String, Object> _userPreferences;

  @override
  void initState() {
    super.initState();
    _selectedGender = Gender.female; // default gender, ladies first!
    _selectedMeasurementSystem = MeasurementSystem.metric; // default

    Future.delayed(Duration.zero, () {
      final Map<String, Object> arguments =
          ModalRoute.of(context).settings.arguments;

      if (arguments != null) {
        setState(() {
          _currentProfileName = arguments['profileName'];
        });

        print('_currentProfileName $_currentProfileName');
      }

      _initUserPreferences();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _initUserPreferences() async {
    final SharedPreferences prefs = await _prefs;

    _userPreferences = json.decode(prefs.getString(_currentProfileName));

    print('userPreferences $_userPreferences');

    // final Gender userSelectedGender =
    //     ;
    // final MeasurementSystem userSelectedMeasurementSystem =
    //     ;
    //
    setState(() {
      _selectedGender = Gender.values[_userPreferences[kGenderStorageKey]];
      _selectedMeasurementSystem =
          MeasurementSystem.values[_userPreferences[kMeasurementStorageKey]];
      _userSavedHeight = _userPreferences[kHeightStorageKey].toString() ??
          kSliderMin.toStringAsFixed(1);
      _userSavedWeight =
          (_userPreferences[kWeightStorageKey] as num).round().toString() ??
              kMinWeight.round().toString();
      _userSavedAge =
          _userPreferences[kAgeStorageKey].toString() ?? kMinAge.toString();
    });

    // print('userSelectedGender $userSelectedGender');
    // print('userSelectedMeasurement $userSelectedMeasurementSystem');
    // print('_userSavedHeight $_userSavedHeight');
    // print('_userSavedWeight $_userSavedWeight');
    // print('_userSavedAge $_userSavedAge');
  }

  Future<void> _storeValues() async {
    final SharedPreferences prefs = await _prefs;

    Map<String, Object> userPreferences = {
      kGenderStorageKey: _selectedGender.index,
      kMeasurementStorageKey: _selectedMeasurementSystem.index,
      kHeightStorageKey: _heightController.text.isEmpty
          ? kSliderMin
          : double.parse(_heightController.text),
      kWeightStorageKey: _weightController.text.isEmpty
          ? kMinWeight.round()
          : int.parse(_weightController.text),
      kAgeStorageKey:
          _ageController.text.isEmpty ? kMinAge : int.parse(_ageController.text)
    };

    prefs.setString(_currentProfileName, json.encode(userPreferences));

    ShowSnackbar(
      currentContext: context,
      textMessage: 'Your preferences are saved successfully!',
      displayDuration: 2,
    )..showSuccess();

    // Send back changed values to the main screen, to instantly update the preferences
    Navigator.pop(context, <String, dynamic>{
      kGenderStorageKey: _selectedGender,
      kMeasurementStorageKey: _selectedMeasurementSystem,
      kHeightStorageKey: _heightController.text.isNotEmpty
          ? double.parse(_heightController.text)
          : kSliderMin,
      kWeightStorageKey: _weightController.text.isNotEmpty
          ? double.parse(_weightController.text)
          : kMinWeight,
      kAgeStorageKey: _ageController.text.isNotEmpty
          ? int.parse(_ageController.text)
          : kMinAge,
    });
  }

  Color _getColor() {
    return _selectedGender == Gender.male
        ? Colors.cyanAccent
        : kBottomContainerColour;
  }

  Color _getTextColor() {
    return _selectedGender == Gender.male ? Colors.blueGrey : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: ReusableCard(
                colour: kActiveCardColour,
                cardChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Your default app preferences:',
                        textAlign: TextAlign.center,
                        style: kBodyTextStyle,
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 5,
                      indent: 20,
                      endIndent: 20,
                      color: _getColor(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 4.0, 5.0, 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender:',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: _getColor(),
                                value: Gender.male,
                                groupValue: _selectedGender,
                                onChanged: (value) =>
                                    setState(() => _selectedGender = value),
                              ),
                              Text(
                                'Male',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Radio(
                                activeColor: _getColor(),
                                value: Gender.female,
                                groupValue: _selectedGender,
                                onChanged: (value) =>
                                    setState(() => _selectedGender = value),
                              ),
                              Text(
                                'Female',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 4.0, 5.0, 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Measurement:',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Row(
                              children: [
                                Radio(
                                  activeColor: _getColor(),
                                  value: MeasurementSystem.metric,
                                  groupValue: _selectedMeasurementSystem,
                                  onChanged: (value) => setState(
                                      () => _selectedMeasurementSystem = value),
                                ),
                                Text(
                                  'Metric',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Radio(
                                  activeColor: _getColor(),
                                  value: MeasurementSystem.imperial,
                                  groupValue: _selectedMeasurementSystem,
                                  onChanged: (value) => setState(
                                      () => _selectedMeasurementSystem = value),
                                ),
                                Text(
                                  'Imperial',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                          ],
                        )),
                    ReusableTextContainer(
                      colour: _getColor(),
                      iconText: 'Height',
                      maxLength: 3,
                      hintText: 'Height in feet ex. 5.7',
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormattersList: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d*)'),
                        ),
                      ],
                      controller: _heightController..text = _userSavedHeight,
                      initTextValue: _userSavedHeight,
                    ),
                    ReusableTextContainer(
                      colour: _getColor(),
                      iconText: 'Weight',
                      maxLength: 3,
                      hintText: 'Weight in lbs ex. 132',
                      keyboardType: TextInputType.number,
                      inputFormattersList: [kAllowOnlyInt],
                      controller: _weightController..text = _userSavedWeight,
                      initTextValue: _userSavedWeight,
                    ),
                    ReusableTextContainer(
                      colour: _getColor(),
                      iconText: 'Age',
                      maxLength: 2,
                      hintText: 'Years equal or between 10 to 90',
                      keyboardType: TextInputType.number,
                      inputFormattersList: [kAllowOnlyInt],
                      controller: _ageController..text = _userSavedAge,
                    ),
                    ButtonBar(
                      children: [
                        buildElevatedButton(
                          buttonText: 'Save',
                          onPressed: () {
                            //Do type validations before storing data in shared preferences
                            if (_heightController.text.isNotEmpty) {
                              final double height =
                                  double.parse(_heightController.text);

                              if (height < kSliderMin || height > kSliderMax) {
                                //  show error
                                ShowSnackbar(
                                  currentContext: context,
                                  textMessage:
                                      'Height should be equal to or between $kSliderMin and $kSliderMax feet only!',
                                )..showError();
                                return;
                              }
                            }

                            if (_weightController.text.isNotEmpty) {
                              final int weight =
                                  int.parse(_weightController.text);

                              if (weight < kMinWeight.round() ||
                                  weight > kMaxWeight.round()) {
                                //  show error
                                ShowSnackbar(
                                  currentContext: context,
                                  textMessage:
                                      'Weight should be equal to or between ${kMinWeight.round()} and ${kMaxWeight.round()} pounds only!',
                                )..showError();
                                return;
                              }
                            }

                            if (_ageController.text.isNotEmpty) {
                              final int age = int.parse(_ageController.text);

                              if (age < kMinAge || age > kMaxAge) {
                                //  show error
                                ShowSnackbar(
                                  currentContext: context,
                                  textMessage:
                                      'Age should be equal to or between $kMinAge and $kMaxAge only!',
                                )..showError();
                                return;
                              }
                            }

                            //  print('''
                            //  entered height ${_heightController.text.isNotEmpty ? _heightController.text : 'No height netered'},
                            // entered weight ${_weightController.text},
                            // entered age ${_ageController.text},
                            // selecetdGender ${_selectedGender.index},
                            // selecetdGenderGEt ${Gender.values[_selectedGender.index]}
                            //  ''');

                            _storeValues();
                          },
                        ),
                        buildElevatedButton(
                          buttonText: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildElevatedButton(
      {@required String buttonText, @required Function onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return _getColor().withOpacity(0.5);
            return _getColor(); // Use the component's default.
          },
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 18.0,
          color: _getTextColor(),
        ),
      ),
    );
  }
}
