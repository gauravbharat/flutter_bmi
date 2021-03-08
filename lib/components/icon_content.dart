import 'package:flutter/material.dart';
import '../constants.dart';

class IconButtonsGender extends StatelessWidget {
  IconButtonsGender({
    @required this.buttonIcon,
    @required this.label,
  });
  final IconData buttonIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          buttonIcon,
          size: kIconSize,
        ),
        SizedBox(
          height: kSizedBoxHeight,
        ),
        Text(
          label,
          style: kStyleLabelText,
        )
      ],
    );
  }
}
