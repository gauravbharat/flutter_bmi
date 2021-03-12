import 'package:bmi_calculator/components/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class NewProfilePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Please create a new profile:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _controller,
                autofocus: false,
                maxLength: 10,
                cursorColor: Colors.greenAccent,
                decoration: InputDecoration(
                  labelText: 'Profile Name',
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                  helperText: 'Ex. self, mom, dad, etc. without spaces',
                  helperStyle: TextStyle(fontSize: 14.0),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.person_add,
                  ),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-Z]"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.isEmpty) {
                  ShowSnackbar(
                      currentContext: context,
                      textMessage: 'Please enter a valid profile name!')
                    ..showError();
                } else {
                  Navigator.pushNamed(context, kRouteNames['home'],
                      arguments: <String, Object>{
                        'newProfileName': _controller.text,
                      });
                }
              },
              child: Text(
                'Create Profile*',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueGrey,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.greenAccent.withOpacity(0.5);
                    return Colors.greenAccent; // Use the component's default.
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '*New profile would be created with system default settings. You may set your app preferences later in the app settings for this profile.',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
