import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:bmi_calculator/components/show_snackbar.dart';

//TODO create user profiles for saved preferences, with security or fb-login?

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> _storedUserProfiles;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfileList();
  }

  Future<void> _getProfileList() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _storedUserProfiles = prefs.getStringList(kProfileListKey);
    });
    print('_storedUserProfiles $_storedUserProfiles');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('BMI User Profiles'),
      //   automaticallyImplyLeading: false,
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              kIsWeb ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: Text(
                'Create a new profile:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kIsWeb ? 70.0 : 8.0),
              child: Container(
                padding: EdgeInsets.all(kIsWeb ? 20.0 : 15.0),
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
                onPressed: () async {
                  if (_controller.text.isEmpty) {
                    ShowSnackbar(
                        currentContext: context,
                        textMessage: 'Please enter a valid profile name!')
                      ..showError();
                  } else {
                    final SharedPreferences prefs = await _prefs;
                    if (prefs.containsKey(_controller.text)) {
                      ShowSnackbar(
                          currentContext: context,
                          textMessage:
                              'Profile ${_controller.text} already exists, please choose a different name!')
                        ..showError();
                    } else {
                      List<String> stringList =
                          prefs.containsKey(kProfileListKey)
                              ? prefs.getStringList(kProfileListKey)
                              : <String>[];
                      stringList.add(_controller.text);

                      prefs.setStringList(kProfileListKey, stringList);
                      await _getProfileList();

                      Navigator.pushNamed(context, kRouteNames['home'],
                          arguments: <String, Object>{
                            'profileName': _controller.text,
                            'profileMode': ProfileMode.createProfile
                          });

                      _controller.text = '';
                    }
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
            ),
            _buildProfileList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileList() {
    if (_storedUserProfiles == null) {
      return Container();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kIsWeb ? 50.0 : 15.0),
          child: Text(
            'Select existing profile (total: ${_storedUserProfiles.length}):',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            height: 50.0,
            child: _buildProfileTiles(),
            // ListView(
            //   scrollDirection: Axis.horizontal,
            //   children: _buildProfileTiles(),
            //
            // ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Select a profile by scrolling left-to-right and tapping on any one.',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;

              final result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete profiles'),
                      content: Text(
                          'This will clear all your stored profiles! Do you wish to continue?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      backgroundColor: Colors.redAccent.withOpacity(0.9),
                    );
                  });

              if (result) {
                prefs.clear();
                _getProfileList();
              }
            },
            child: Text(
              'Clear All Profiles',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.redAccent.withOpacity(0.5);
                  return Colors.redAccent; // Use the component's default.
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  ListView _buildProfileTiles() {
    List<Widget> profileTile = <Widget>[];

    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _storedUserProfiles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, kRouteNames['home'],
                  arguments: <String, Object>{
                    'profileName': _storedUserProfiles[index],
                    'profileMode': ProfileMode.loadProfile
                  });
            },
            child: Container(
              alignment: Alignment.center,
              width: 160.0,
              color: index.isEven ? Colors.yellowAccent : Colors.greenAccent,
              child: Text(
                _storedUserProfiles[index],
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        });
  }
}
