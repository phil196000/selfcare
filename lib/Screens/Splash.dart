import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/Welcome.dart';
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

  bool passwordError = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future login(String _email, String _password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.toLowerCase().trim(), password: _password.trim());

      if (userCredential.user != null) {
        getIt.get<Store<AppState>>().dispatch(GetUserAction(email: _email));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Main(),
            ));

        return 'success';
      } else {
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
        this.setState(() {
          emailError['visible'] = true;
          emailError['message'] = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        setState(() {
          passwordError = true;
        });
      } else {
        CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        // QuerySnapshot snapshot =
        users
            .where('email', isEqualTo: _email.toLowerCase().trim())
            // .where('password', isEqualTo: _password)
            .get()
            .then((QuerySnapshot snapshot) {
          log('successful');
          if (snapshot.size > 0) {
            snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
              UserModel userModel =
                  UserModel.fromJson(documentSnapshot.data()!);
              if (userModel.password == _password) {
                getIt.get<Store<AppState>>().dispatch(GetUserAction(email: _email));
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

                // getIt
                //     .get<Store<AppState>>()
                //     .dispatch(GetUserAction(email: _email));
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
      // log(e.message!, name: 'error auth');
      return 'error';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.forward().then((value) {
      _prefs.then((SharedPreferences prefs) {
        var email = prefs.getString('email') ?? null;
        var password = prefs.getString('password') ?? null;
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
