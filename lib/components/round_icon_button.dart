import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton(
      {@required this.fillColor,
      @required this.buttonIcon,
      this.onPressed,
      this.onLongPressed});
  final Color fillColor;
  final Icon buttonIcon;
  final Function onPressed;
  final Function onLongPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      constraints: BoxConstraints.tightFor(
        width: 45.0,
        height: 45.0,
      ),
      shape: CircleBorder(),
      // shape:
      // RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      fillColor: fillColor,
      child: buttonIcon,
      onPressed: onPressed,
      onLongPress: onLongPressed,
    );
  }
}
