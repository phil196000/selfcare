import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/actions.dart';

import 'Actions/GetUserAction.dart';
import 'AppState.dart';

// A middleware takes in 3 parameters: your Store, which you can use to
// read state or dispatch new actions, the action that was dispatched,
// and a `next` function. The first two you know about, and the `next`
// function is responsible for sending the action to your Reducer, or
// the next Middleware if you provide more than one.
//
// Middleware do not return any values themselves. They simply forward
// actions on to the Reducer or swallow actions in some special cases.
void fetchUser(Store<AppState> store, action, NextDispatcher next) {
  // If our Middleware encounters a `FetchTodoAction`
  if (action is GetUserAction) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // QuerySnapshot snapshot =
    users
        .where('email', isEqualTo: GetUserAction().email)
        .get()
        .then((QuerySnapshot snapshot) {
      log('successful');
      if (snapshot.size > 0) {
        snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          UserModel userModel = UserModel.fromJson(documentSnapshot.data()!);
          store.dispatch(GetUserActionSuccess(userModelUser: userModel));
        });
      }
    });
    log('user fetch done');
  } else if (action is SelectedDateAction) {
    store.dispatch(SelectedDateActionSuccess(selected: action.selected));
  }

  // Make sure our actions continue on to the reducer.
  next(action);
}
