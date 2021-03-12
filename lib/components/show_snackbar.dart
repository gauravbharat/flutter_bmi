import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ShowSnackbar {
  const ShowSnackbar({
    @required this.currentContext,
    @required this.textMessage,
    this.displayDuration = 3,
  });

  final BuildContext currentContext;
  final String textMessage;
  final int displayDuration;

  void showSuccess() {
    _showMessage(backgroundColor: Colors.greenAccent, textColor: Colors.black);
  }

  void showError() {
    _showMessage(backgroundColor: Colors.redAccent, textColor: Colors.white);
  }

  void _showMessage(
      {@required Color backgroundColor, @required Color textColor}) {
    final showMessage = SnackBar(
      backgroundColor: backgroundColor,
      duration: Duration(seconds: displayDuration),
      content: Text(
        textMessage,
        style: TextStyle(
          fontSize: 18.0,
          color: textColor,
        ),
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(currentContext).showSnackBar(showMessage);
  }
}
