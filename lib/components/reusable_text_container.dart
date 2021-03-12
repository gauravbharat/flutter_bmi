import 'package:bmi_calculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReusableTextContainer extends StatefulWidget {
  ReusableTextContainer({
    @required this.colour,
    @required this.iconText,
    @required this.maxLength,
    this.hintText,
    this.inputFormattersList,
    this.controller,
    this.initTextValue,
  });

  final Color colour;
  final List<TextInputFormatter> inputFormattersList;
  final String iconText;
  final String hintText;
  final int maxLength;
  final TextEditingController controller;
  final String initTextValue;

  @override
  _ReusableTextContainerState createState() => _ReusableTextContainerState();
}

class _ReusableTextContainerState extends State<ReusableTextContainer> {
  String _dynamicHelperText;
  bool _loadingState = false;
  String _suffixText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _suffixText = (widget.iconText == 'Height')
        ? 'ft'
        : (widget.iconText == 'Weight')
            ? 'lb'
            : 'yrs';
    _loadingState = true;
  }

  void _setHelperText(value) {
    switch (widget.iconText) {
      case 'Height':
        if (value.isNotEmpty) {
          try {
            final double enteredHeight = double.parse(value);
            final String approxHeightInCms =
                (enteredHeight * kHeightConstant).toStringAsFixed(0);

            setState(() {
              _dynamicHelperText = 'Approx ${approxHeightInCms}cm';
            });
          } on FormatException {
            //
          }
        } else {
          setState(() {
            _dynamicHelperText = kHelperTextHeightInitValue;
          });
        }
        break;

      case 'Weight':
        if (value.isNotEmpty) {
          try {
            final int enteredWeight = int.parse(value);
            final String approxWeightInKgs =
                (enteredWeight * kWeightConstant).toStringAsFixed(0);

            setState(() {
              _dynamicHelperText = 'Approx ${approxWeightInKgs}kg';
            });
          } on FormatException {
            //
          }
        } else {
          setState(() {
            _dynamicHelperText = kHelperTextWeightInitValue;
          });
        }
        break;
    }
  }

  void _setInitValuesHelperText() {
    //let the container be built before creating helper text
    Future.delayed(Duration(seconds: 1), () {
      _loadingState = false;
      // print(widget.initTextValue);
      _setHelperText(widget.initTextValue ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingState) _setInitValuesHelperText();
    return buildTextFieldContainer();
  }

  Container buildTextFieldContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 4.0),
      child: TextField(
        controller: widget.controller,
        autofocus: false,
        decoration: InputDecoration(
          suffixText: _suffixText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.colour,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.colour,
            ),
          ),
          filled: true,
          hintText: widget.hintText,
          helperText: _dynamicHelperText,
          icon: Text(
            widget.iconText,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        maxLength: widget.maxLength,
        cursorColor: widget.colour,
        keyboardType: TextInputType.number,
        inputFormatters: widget.inputFormattersList,
        onChanged: (value) => _setHelperText(value),
      ),
    );
  }
}
