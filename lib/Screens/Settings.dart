import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/SettingCardModels.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/Login.dart';
import 'package:selfcare/Screens/Settings/Account.dart';
import 'package:selfcare/Screens/Settings/Update.dart';
import 'package:selfcare/Screens/Settings/Reminder.dart';
import 'package:selfcare/Screens/Settings/SettingCard.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/Actions/GetUserAction.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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
    return StoreConnector(
      builder: (context, AppState state) {
        return Scaffold(
          body: SafeArea(
              child: Stack(
            children: [
              Background(),
              ListView(
                padding:
                    EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 50),
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
                            } else if (settingCardModel.title == 'Reminder') {
                              pushNewScreen(context, screen: Reminder());
                            } else if (settingCardModel.title == 'Account') {
                              getIt.get<Store<AppState>>().dispatch(
                                  GetUserEditAction(
                                      userEditModel: state.userModel));
                              pushNewScreen(context,
                                  screen: Account(
                                    userModel: state.userModel,
                                  ));
                            } else if (settingCardModel.title ==
                                'Rate This App') {
                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (context) => RatingDialog(
                                  // your app's name?
                                  title: 'Rate this App',
                                  // encourage your user to leave a high rating?
                                  message:
                                      'Tap a star to set your rating. Add more description here if you want.',
                                  // your app's logo?
                                  image: Image.asset('lib/Assets/logo.png'),
                                  submitButton: 'Submit',
                                  initialRating: 1,

                                  onCancelled: () => print('cancelled'),
                                  onSubmitted: (response) {
                                    print(
                                        'rating: ${response.rating}, comment: ${response.comment}');
                                    if (response.rating > 0) {
                                      // log(response.rating.toString());
                                      DocumentReference docRef =
                                          FirebaseFirestore.instance
                                              .collection('ratings')
                                              .doc();
                                      docRef.set({
                                        'rating': response.rating,
                                        'created_at': DateTime.now()
                                            .millisecondsSinceEpoch,
                                        'comment': response.comment,
                                        'id': docRef.id,
                                        'user': {
                                          'id': state.userModel!.user_id,
                                          'phone_number':
                                              state.userModel!.phone_number,
                                          'full_name':
                                              state.userModel!.full_name,
                                          'email': state.userModel!.email
                                        },
                                      }).then((value) => null);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        // onVisible: () => Timer(
                                        //     Duration(seconds: 2),
                                        //         () => Navigator.of(context).pop()),
                                        backgroundColor: DefaultColors().green,
                                        content: Container(
                                          // color: Colors.yellow,
                                          child: WhiteText(
                                            text:
                                                'Rating submitted successfully',
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ));
                                      // Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        // onVisible: () => Timer(
                                        //     Duration(seconds: 2),
                                        //         () => Navigator.of(context).pop()),
                                        backgroundColor:
                                            DefaultColors().primary,
                                        content: Container(
                                          // color: Colors.yellow,
                                          child: WhiteText(
                                            text:
                                                'Tap a star and /or leave a comment to submit a rating',
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 2000),
                                      ));
                                    }
                                    // // TODO: add your own logic
                                    // if (response.rating < 3.0) {
                                    //   // send their comments to your email or anywhere you wish
                                    //   // ask the user to contact you instead of leaving a bad review
                                    // } else {
                                    //
                                    // }
                                  },
                                ),
                              );
                            } else if (settingCardModel.title ==
                                'Check for Update') {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => Update(
                                    platform: Theme.of(context).platform,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
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
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
