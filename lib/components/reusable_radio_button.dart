import 'package:flutter/material.dart';

class ReusableRadioButton extends StatelessWidget {
  ReusableRadioButton({
    @required this.activeColor,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
  });

  final Color activeColor;
  final dynamic value;
  final dynamic groupValue;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Radio(
      activeColor: activeColor,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
