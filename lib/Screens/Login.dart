import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/DefaultInput.dart';
import 'package:selfcare/CustomisedWidgets/PasswordInput.dart';
import 'package:selfcare/CustomisedWidgets/PrimaryButton.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/TextButton.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Navigation/AdminBottomNav.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/ChatActions.dart';
import 'package:selfcare/redux/Actions/GetBodyWeightAction.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';
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

  Future<void> _loginCredentialsSave({required String passwordCrypt}) async {
    final SharedPreferences prefs = await _prefs;

    prefs
        .setString(
          "email",
          _email.text.toLowerCase().trim(),
        )
        .then((value) => prefs
            .setString(
              "password",
              passwordCrypt,
            )
            .then((value) => log('success')));
  }

//firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> alert({String message = ''}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('ALERT')],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RedText(text: message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: DarkGreenText(
                text: 'CLOSE',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future login() async {
    setState(() {
      loading = true;
    });
    try {

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.text.toLowerCase().trim(), password: _password.text.trim());

      if (userCredential.user != null) {
        setState(() {
          loading = false;
        });
        _loginCredentialsSave(passwordCrypt: _password.text.trim()).then((value) {
          getIt
              .get<Store<AppState>>()
              .dispatch(GetUserAction(email: _email.text));
          getUserData();
          // Timer(
          //     Duration(seconds: 3),
          //     () => Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => Main(),
          //         )));
        });

        // return 'success';
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
        log('Wrong password provided for that user.');
        setState(() {
          passwordError = true;
        });
      } else {
        getUserData();
      }
      log(e.message!, name: 'error auth');
      return 'error';
    }
  }

  void getUserData() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // QuerySnapshot snapshot =
    users
        .where('email', isEqualTo: _email.text.toLowerCase().trim())
        // .where('password', isEqualTo: _password.text)
        .get()
        .then((QuerySnapshot snapshot) {
      log('successful');
      if (snapshot.size > 0) {
        snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          UserModel userModel = UserModel.fromJson(documentSnapshot.data()!);
          // if (userModel.password ==
          //     Crypt.sha256(_password.text,
          //             rounds: 10000, salt: 'selfcarepasswordsalt')
          //         .toString()) {

          if (userModel.password == _password.text.trim()) {
            getIt
                .get<Store<AppState>>()
                .dispatch(GetUserActionSuccess(userModelUser: userModel));
            getIt
                .get<Store<AppState>>()
                .dispatch(GetGlucoseAction(user_id: userModel.user_id));
            getIt
                .get<Store<AppState>>()
                .dispatch(GetPressureAction(user_id: userModel.user_id));
            getIt
                .get<Store<AppState>>()
                .dispatch(GetWeightAction(user_id: userModel.user_id));
            getIt
                .get<Store<AppState>>()
                .dispatch(ChatAction(user_id: userModel.user_id));
            _loginCredentialsSave(
                    passwordCrypt:
                        _password.text.trim())
                .then((value) {
              getIt
                  .get<Store<AppState>>()
                  .dispatch(GetUserAction(email: _email.text));
              if (userModel.roles.length > 1) {
                log('i should ran');
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                        title: RedText(
                          text: 'Hello Welcome,\nYou have access to enter as:',
                        ),
                        children: userModel.roles.map((String e) {
                          return Container(
                              margin: EdgeInsets.only(top: 15),
                              child: SimpleDialogOption(
                                onPressed: () {
                                  if (e == 'USER') {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Main(),
                                        ),
                                        (route) => false);
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AdminMain(),
                                        ),
                                        (route) => false);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      e.toLowerCase() == 'user'
                                          ? Icons.person
                                          : e.toLowerCase() == 'manager'
                                              ? Icons.supervised_user_circle
                                              : Icons.admin_panel_settings,
                                      size: 36.0,
                                      color: e.toLowerCase() == 'user'
                                          ? defaultColors.green
                                          : e.toLowerCase() == 'manager'
                                              ? defaultColors.darkblue
                                              : defaultColors.primary,
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 16.0),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            color: e.toLowerCase() == 'user'
                                                ? defaultColors.green
                                                : e.toLowerCase() == 'manager'
                                                    ? defaultColors.darkblue
                                                    : defaultColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }).toList());
                  },
                );
              } else {
                if (userModel.roles.contains('USER')) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Main(),
                      ),
                      (route) => false);
                }
              }
            });
          } else {
            alert(message: 'Wrong Password, try again');
          }
        });
      } else {
        alert(message: 'User not found, contact Admin for an account');
      }
    });
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
                          flex: 9,
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
                            child: ListView(
                              padding: EdgeInsets.only(bottom: 20),
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
                  ),
                ],
              );
            },
          )),
        );
      },
    );
  }
}
