import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Navigation/AdminBottomNav.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/Welcome.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/Actions/GetBodyWeightAction.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';
import 'package:selfcare/redux/Actions/GetUserAction.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

//errors
  Map<String, dynamic> emailError = {'visible': false, 'message': null};
  Map<String, dynamic> netWorkError = {'visible': false, 'message': ''};
  DefaultColors defaultColors = DefaultColors();
  bool passwordError = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void getUserData({required String email, required String password}) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // QuerySnapshot snapshot =
    log(email, name: 'email');
    users
        .where('email', isEqualTo: email.toLowerCase().trim())
        // .where('password', isEqualTo: _password.text)
        .get()
        .then((QuerySnapshot snapshot) {
      log('successful');
      if (snapshot.size > 0) {
        snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          UserModel userModel = UserModel.fromJson(documentSnapshot.data()!);
          if (userModel.password == password) {
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

            getIt.get<Store<AppState>>().dispatch(GetUserAction(email: email));

            getIt.get<Store<AppState>>().dispatch(GetUserAction(email: email));
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
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Welcome(),
                ),
                (route) => false);
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Welcome(),
            ),
            (route) => false);
      }
    });
  }

  Future login(String _email, String _password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.toLowerCase().trim(), password: _password.trim());

      if (userCredential.user != null) {
        // getIt.get<Store<AppState>>().dispatch(GetUserAction(email: _email));
        getUserData(email: _email, password: _password);

        // return 'success';
      } else {
        log(_email, name: 'email');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Welcome(),
            ),
            (route) => false);
      }
      // return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // this.setState(() {
        //   emailError['visible'] = true;
        //   emailError['message'] = 'No user found for that email.';
        // });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Welcome(),
            ),
            (route) => false);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Welcome(),
            ),
            (route) => false);
      } else {
        getUserData(email: _email, password: _password);
      }
      // log(e.message!, name: 'error auth');
      // return 'error';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.forward().then((value) {
      _prefs.then((SharedPreferences prefs) {
        var email = prefs.getString('email') ?? null;
        var password = prefs.getString('password') ?? null;
        log(email.toString(), name: 'email');
        log(password.toString(), name: 'password');
        if (email != null && password != null) {
          login(email, password);
          // Navigator.pushAndRemoveUntil(
          //     context, MaterialPageRoute(builder: (context) => Main(),), (
          //     route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Welcome(),
              ),
              (route) => false);
        }
      });
    });
    // if(_controller.isCompleted){
    //   log('done animating');
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Background(),
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset('lib/Assets/logo.png'),
            ),
          )
        ],
      )),
    );
  }
}
