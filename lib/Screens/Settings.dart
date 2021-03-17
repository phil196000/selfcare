import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/Data/SettingCardModels.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/Login.dart';
import 'package:selfcare/Screens/Settings/SettingCard.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final Function hidenavbar;

  Settings({required this.hidenavbar});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  DefaultColors defaultColors = DefaultColors();

  Future<void> logout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('SIGN OUT')],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RedText(text: 'You are about to sign out'),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: DarkRedText(
                    text: 'Do you want to proceed?',
                    weight: FontWeight.normal,
                    size: 14,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: RedText(
                text: 'NO',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: DarkGreenText(
                text: 'YES',
              ),
              onPressed: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _logout() async {
    final SharedPreferences prefs = await _prefs;
    // final String counter = (prefs.getString('email') ?? 'Hello');

    prefs.clear().then((value) {
      this.widget.hidenavbar(true);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return Login();
        },
      ), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Background(),
          ListView(
            padding: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 50),
            children: [
              ...[
                {
                  'title': 'Account',
                  'avatar': Icons.person,
                  'color': defaultColors.primary
                },
                {
                  'title': 'Reminder',
                  'avatar': Icons.alarm,
                  'color': defaultColors.darkRed
                },
                {
                  'title': 'About',
                  'avatar': Icons.history_edu,
                  'color': defaultColors.black
                },
                {
                  'title': 'Privacy Policy',
                  'avatar': Icons.privacy_tip,
                  'color': defaultColors.darkblue
                },
                {
                  'title': 'Rate This App',
                  'avatar': Icons.star_rate,
                  'color': defaultColors.green
                },
                {
                  'title': 'Check for Update',
                  'avatar': Icons.system_update,
                  'color': defaultColors.yellow
                },
                {
                  'title': 'License',
                  'avatar': Icons.file_copy,
                  'color': defaultColors.cyan
                },
                {
                  'title': 'Contact Us',
                  'avatar': Icons.contact_phone_sharp,
                  'color': defaultColors.grey
                },
                {
                  'title': 'Sign Out',
                  'avatar': Icons.logout,
                  'color': Colors.deepPurple
                },
              ].map((e) {
                SettingCardModel settingCardModel =
                    SettingCardModel.fromJson(e);
                return Container(
                    margin: EdgeInsets.only(bottom: 18),
                    child: SettingCard(
                      onPressed: () {
                        if (settingCardModel.title == 'Sign Out') {
                          logout();
                        }
                      },
                      title: settingCardModel.title,
                      avatar: settingCardModel.avatar,
                      color: settingCardModel.color,
                    ));
              })
            ],
          ),
        ],
      )),
    );
  }
}
