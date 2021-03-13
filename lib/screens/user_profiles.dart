import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilesPage extends StatelessWidget {
  UserProfilesPage(this._userPreference);
  final _userPreference;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    // final Map<String, Object> _arguments =
    //     ModalRoute.of(context).settings.arguments;
    //
    // print('arguments $_arguments');
    print('_userPreference $_userPreference');

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profiles'),
        automaticallyImplyLeading: false,
      ),
    );
  }
}
