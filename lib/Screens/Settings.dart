import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/Screens/Settings/SettingCard.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  DefaultColors defaultColors = DefaultColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Background(),
          ListView(
            padding: EdgeInsets.only(top: 15, right: 10, left: 10),
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
              }
              ].map((e) => Container(
                  margin: EdgeInsets.only(bottom: 18),
                  child: SettingCard(
                    title: e['title'],
                    avatar: e['avatar'],
                    color: e['color'],
                  )))
            ],
          ),
        ],
      )),
    );
  }
}
