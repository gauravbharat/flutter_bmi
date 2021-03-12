import 'package:flutter/material.dart';
import '../constants.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    @required this.colour,
    @required this.buttonText,
    @required this.onTap,
    this.buttonTextColour: Colors.white,
  });
  final Color colour;
  final String buttonText;
  final Color buttonTextColour;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: colour,
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.only(bottom: 20.0),
        width: double.infinity,
        height: kBottomContainerHeight,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: buttonTextColour,
            ),
          ),
        ),
      ),
    );
  }
}
