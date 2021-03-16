import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';

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
          store.dispatch(GetGlucoseAction(user_id: userModel.user_id));
          store.dispatch(GetPressureAction(user_id: userModel.user_id));
        });
      }
    });
    log('user fetch done');
  } else if (action is GetGlucoseAction) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(store.state.userModel!.user_id)
        .collection('bloodglucose');
    log(store.state.userModel!.user_id);
    // QuerySnapshot snapshot =
    List items = [];
    users
        .orderBy('date_for_timestamp_millis', descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      log(snapshot.size.toString());
      log('successful glucose blood');
      if (snapshot.size > 0) {
        MainBloodGlucoseModel mainBloodGlucoseModel;
        snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          log(documentSnapshot.id);
          items.add({
            'data': documentSnapshot.data(),
            'id': documentSnapshot.reference
          });
        });
        store.dispatch(GetGlucoseActionSuccess(
          glucose: items,
        ));
      } else {
        store.dispatch(GetGlucoseActionSuccess(
          glucose: items,
        ));
      }
      store.dispatch(SelectedDateAction(selected: store.state.selectedDate,screen: 'Blood Glucose'));
    });
    // store.dispatch(SelectedDateAction(selected: store.state.selectedDate));
  } else if (action is SelectTimeValuesAction) {
    if (action.screen == 'Blood Glucose') {
      log('glucose section');
      if (store.state.bloodglucose!.length > 0) {
        store.state.bloodglucose!.forEach((element) {
          MainGlucoseModelwithID initMainGlucoseModelwithID =
              MainGlucoseModelwithID.fromJson(element);
          MainBloodGlucoseModel initMainBloodGlucoseModel =
              MainBloodGlucoseModel.fromJson(initMainGlucoseModelwithID.data);
          String initSelectedDate =
              '${store.state.selectedDate!.day}-${store.state.selectedDate!.month}-${store.state.selectedDate!.year}';
          log(initSelectedDate);
          if (initMainBloodGlucoseModel.date_for == initSelectedDate) {
            log('match');
            initMainBloodGlucoseModel.readings!.forEach((element) {
              BloodGlucoseModel bloodGlucoseModel =
                  BloodGlucoseModel.fromJson(element);
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  bloodGlucoseModel.created_at);
              TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
              // log(timeOfDay.hour.toString());
              String timeofString =
                  '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute<10?'0${timeOfDay.minute}':timeOfDay.minute}} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}';
              if (action.selected == timeofString) {
                store.dispatch(SelectTimeValuesActionSuccess(
                    selected: bloodGlucoseModel, selectedPressure: null));
              }
            });
            log('found here');
          } else {
            //   // selectedTimes = [];
            log('nothing', name: 'finding date data');
          }
        });
      } else {
        log('else run');
      }
    } else if (action.screen == 'Blood Pressure') {
      log('pressure section');
      if (store.state.bloodpressure!.length > 0) {
        store.state.bloodpressure!.forEach((element) {
          MainPressureModelwithID initMainPressureModelwithID =
              MainPressureModelwithID.fromJson(element);
          MainBloodPressureModel initMainBloodPressureModel =
              MainBloodPressureModel.fromJson(initMainPressureModelwithID.data);
          String initSelectedDate =
              '${store.state.selectedDate!.day}-${store.state.selectedDate!.month}-${store.state.selectedDate!.year}';
          log(initSelectedDate);
          if (initMainBloodPressureModel.date_for == initSelectedDate) {
            log('match');
            initMainBloodPressureModel.readings!.forEach((element) {
              BloodPressureModel bloodPressureModel =
                  BloodPressureModel.fromJson(element);
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  bloodPressureModel.created_at);
              TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
              // log(timeOfDay.hour.toString());
              String timeofString =
                  '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute<10?'0${timeOfDay.minute}':timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}';
              log(action.selected!, name: timeofString);

              if (action.selected == timeofString) {
                log('i ran when selected matched');
                store.dispatch(SelectTimeValuesActionSuccess(
                    selectedPressure: bloodPressureModel, selected: null));
              }
            });
            log('found here');
          } else {
            //   // selectedTimes = [];
            log('nothing', name: 'finding date data');
          }
        });
      } else {
        log('else run');
      }
    }
  }

  // Make sure our actions continue on to the reducer.
  next(action);
}

void fetchPressure(Store<AppState> store, action, NextDispatcher next) {
  // If our Middleware encounters a `FetchTodoAction`
  if (action is GetPressureAction) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(store.state.userModel!.user_id)
        .collection('bloodpressure');
    // log(store.state.userModel!.user_id);
    // QuerySnapshot snapshot =
    List items = [];
    users
        .orderBy('date_for_timestamp_millis', descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      // log(snapshot.size.toString());
      log('successful pressure blood');
      if (snapshot.size > 0) {
        MainBloodGlucoseModel mainBloodGlucoseModel;
        snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          log(documentSnapshot.id);
          items.add({
            'data': documentSnapshot.data(),
            'id': documentSnapshot.reference
          });
        });
        store.dispatch(GetPressureActionSuccess(
          pressure: items,
        ));
      } else {
        store.dispatch(GetPressureActionSuccess(
          pressure: items,
        ));
      }
      store.dispatch(SelectedDateAction(selected: store.state.selectedDate,screen: 'Blood Pressure'));
    });
    // store.dispatch(SelectedDateAction(selected: store.state.selectedDate));
  }

  // Make sure our actions continue on to the reducer.
  next(action);
}

void setDate(Store<AppState> store, action, NextDispatcher next) {
  if (action is SelectedDateAction) {
    log('middle ware first', name: 'middle ware');
    List<String>? selectedTimes = [];
    if (action.screen == 'Blood Glucose' &&
        store.state.bloodglucose!.length > 0) {
      store.state.bloodglucose!.forEach((element) {
        MainGlucoseModelwithID initMainGlucoseModelwithID =
            MainGlucoseModelwithID.fromJson(element);
        MainBloodGlucoseModel initMainBloodGlucoseModel =
            MainBloodGlucoseModel.fromJson(initMainGlucoseModelwithID.data);
        String initSelectedDate =
            '${action.selected!.day}-${action.selected!.month}-${action.selected!.year}';
        if (initMainBloodGlucoseModel.date_for == initSelectedDate) {
          initMainBloodGlucoseModel.readings!.sort((a, b) {
            BloodGlucoseModel forA = BloodGlucoseModel.fromJson(a);
            BloodGlucoseModel forB = BloodGlucoseModel.fromJson(b);
            return forA.created_at - forB.created_at;
          });
          log(initMainBloodGlucoseModel.readings!.length.toString());
          initMainBloodGlucoseModel.readings!.forEach((element) {
            BloodGlucoseModel bloodGlucoseModel =
                BloodGlucoseModel.fromJson(element);
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                bloodGlucoseModel.created_at);
            TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
            // log(timeOfDay.hour.toString());
            selectedTimes.add(
                '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}');
          });
          log('found here');
        }
      });
    }
    if (action.screen == 'Blood Pressure' &&
        store.state.bloodpressure!.length > 0) {
      log('Blood Pressure');
      store.state.bloodpressure!.forEach((element) {
        MainPressureModelwithID initMainPressureModelwithID =
            MainPressureModelwithID.fromJson(element);
        MainBloodPressureModel initMainBloodPressureModel =
            MainBloodPressureModel.fromJson(initMainPressureModelwithID.data);
        String initSelectedDate =
            '${action.selected!.day}-${action.selected!.month}-${action.selected!.year}';
        if (initMainBloodPressureModel.date_for == initSelectedDate) {
          initMainBloodPressureModel.readings!.sort((a, b) {
            BloodGlucoseModel forA = BloodGlucoseModel.fromJson(a);
            BloodGlucoseModel forB = BloodGlucoseModel.fromJson(b);
            return forA.created_at - forB.created_at;
          });
          log(initMainBloodPressureModel.readings!.length.toString());
          initMainBloodPressureModel.readings!.forEach((element) {
            BloodPressureModel bloodPressureModel =
                BloodPressureModel.fromJson(element);
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                bloodPressureModel.created_at);
            TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
            // log(timeOfDay.hour.toString());
            selectedTimes.add(
                '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}');
          });
          log('found here');
        }
      });
    }
    store.dispatch(SelectedDateActionSuccess(
        screen: action.screen,
        selected: action.selected,
        selectedTimes: selectedTimes));
  }
  next(action);
}
