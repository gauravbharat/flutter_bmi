import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReusableTextContainer extends StatelessWidget {
  ReusableTextContainer({
    @required this.colour,
    @required this.iconText,
    @required this.maxLength,
    this.hintText,
    this.inputFormattersList,
    this.helperText,
    this.controller,
  });

  final Color colour;
  final List<TextInputFormatter> inputFormattersList;
  final String iconText;
  final String hintText;
  final int maxLength;
  final String helperText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 4.0),
      child: TextField(
        controller: controller,
        autofocus: false,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: colour,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: colour,
            ),
          ),
          filled: true,
          hintText: hintText,
          helperText: helperText,
          icon: Text(
            iconText,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        maxLength: maxLength,
        cursorColor: colour,
        keyboardType: TextInputType.number,
        inputFormatters: inputFormattersList,
      ),
    );
  }
}
