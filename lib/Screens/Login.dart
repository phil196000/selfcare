import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/DefaultInput.dart';
import 'package:selfcare/CustomisedWidgets/PasswordInput.dart';
import 'package:selfcare/CustomisedWidgets/PrimaryButton.dart';
import 'package:selfcare/CustomisedWidgets/TextButton.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/GetUserAction.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:selfcare/redux/middleware.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DefaultColors defaultColors = DefaultColors();
  bool passwordVisibilty = true;
  bool loading = false;
  String email = '';
  String password = '';

//errors
  Map<String, dynamic> emailError = {'visible': false, 'message': null};
  Map<String, dynamic> netWorkError = {'visible': false, 'message': ''};

  bool passwordError = false;

  //TextEditing controllers
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

//Shared Preference
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _loginCredentialsSave() async {
    final SharedPreferences prefs = await _prefs;

    prefs
        .setString(
          "email",
          _email.text.toLowerCase().trim(),
        )
        .then((value) => prefs
            .setString(
              "password",
              _password.text.trim(),
            )
            .then((value) => log('success')));
  }

//firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  Future login() async {
    setState(() {
      loading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.text.toLowerCase().trim(),
              password: _password.text.trim());

      if (userCredential.user != null) {
        setState(() {
          loading = false;
        });
        _loginCredentialsSave().then((value) {
          getIt.get<Store>().dispatch(GetUserAction(email: _email.text));
          Timer(
              Duration(seconds: 3),
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Main(),
                  )));
        });

        return 'success';
      }
      // return userCredential;
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        this.setState(() {
          emailError['visible'] = true;
          emailError['message'] = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        setState(() {
          passwordError = true;
        });
      }
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: (Store<AppState> store) => store.state,
      builder: (context, AppState state) {
        return Scaffold(
          body: SafeArea(child: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return Stack(
                children: [
                  Background(),
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      Visibility(
                        visible: !isKeyboardVisible,
                        child: Expanded(
                            flex: 4, child: Image.asset('lib/Assets/logo.png')),
                      ),
                      Expanded(
                          flex: 6,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 11, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 22),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: defaultColors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 5),
                                      color: defaultColors.shadowColorGrey,
                                      blurRadius: 10)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DarkRedText(
                                  text: 'Login to enjoy our services',
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: DefaultInput(
                                    error: emailError,
                                    hint: 'Email',
                                    controller: _email,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: PasswordInput(
                                    passwordError: passwordError,
                                    controller: _password,
                                    hint: 'Password',
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: ButtonText(
                                    onPressed: () {},
                                    text: 'Forgot Password?',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: state.userModelFetch,
                                      child: Container(
                                        color: defaultColors.white,
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  defaultColors.primary),
                                          strokeWidth: 3,
                                          backgroundColor:
                                              defaultColors.shadowColorRed,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      alignment: Alignment.centerRight,
                                      child: PrimaryButton(
                                        horizontalPadding: 50,
                                        text: 'Login',
                                        onPressed: () {
                                          if (_email.text.contains('@') &&
                                              _email.text.contains('.') &&
                                              _email.text.length > 5 &&
                                              _password.text.length > 7) {
                                            this.setState(() {
                                              emailError['visible'] = false;
                                              emailError['message'] = null;
                                              passwordError = false;
                                            });

                                            login();
                                          }
                                          if (!_email.text.contains('@')) {
                                            this.setState(() {
                                              emailError['visible'] = true;
                                              emailError['message'] =
                                                  "Email must contain @";
                                            });
                                          } else if (!_email.text
                                              .contains('.')) {
                                            this.setState(() {
                                              emailError['visible'] = true;
                                              emailError['message'] =
                                                  "Email must contain .";
                                            });
                                          } else {
                                            this.setState(() {
                                              emailError['visible'] = false;
                                              emailError['message'] = null;
                                            });
                                          }
                                          if (_password.text.length < 8) {
                                            this.setState(() {
                                              passwordError = true;
                                            });
                                          }
                                          // log(_email.text);
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                      Visibility(
                          visible: !isKeyboardVisible, child: Spacer(flex: 2))
                    ],
                  )
                ],
              );
            },
          )),
        );
      },
    );
  }
}
