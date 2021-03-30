import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/Chats.dart';
import 'package:selfcare/Data/HealthTip.dart';
import 'package:selfcare/Data/RecordsModel.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/redux/Actions/ChatActions.dart';
import 'package:selfcare/redux/Actions/GetBodyWeightAction.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';
import 'package:selfcare/redux/Actions/GetRecordsAction.dart';
import 'package:selfcare/redux/Actions/GetUsersAction.dart';
import 'package:selfcare/redux/Actions/TipsAction.dart';

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
        .where('email', isEqualTo: action.email)
        .get()
        .then((QuerySnapshot snapshot) {
      log('successful');
      if (snapshot.size > 0) {
        snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          UserModel userModel = UserModel.fromJson(documentSnapshot.data()!);
          store.dispatch(GetUserActionSuccess(userModelUser: userModel));
          store.dispatch(GetGlucoseAction(user_id: userModel.user_id));
          store.dispatch(GetPressureAction(user_id: userModel.user_id));
          store.dispatch(GetWeightAction(user_id: userModel.user_id));
        });
      }
    });
    log('user fetch done');
  } else if (action is GetUserEditAction) {
    store.dispatch(
        GetUserEditActionSuccess(userEditModel: action.userEditModel));
  } else if (action is GetGlucoseAction) {
    // if (action.user_id.length > 0) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(action.user_id.length > 0
            ? action.user_id
            : store.state.userModel!.user_id)
        .collection('bloodglucose');
    log(action.user_id, name: 'user id');
    // QuerySnapshot snapshot =
    List items = [];
    users
        .orderBy('date_for_timestamp_millis', descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      log(snapshot.size.toString());
      log('successful glucose blood');
      if (snapshot.size > 0) {
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
      store.dispatch(SelectedDateAction(
          selected: store.state.selectedDate, screen: 'Blood Glucose'));
    });
    // }
    // store.dispatch(SelectedDateAction(selected: store.state.selectedDate));
  } else if (action is SelectTimeValuesAction) {
    log(action.screen, name: 'screen');
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
                  '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}';
              if (action.selected == timeofString) {
                log('matches here too', name: 'SelectTimeValuesAction');
                store.dispatch(SelectTimeValuesActionSuccess(
                    selectedWeight: null,
                    selected: bloodGlucoseModel,
                    selectedPressure: null));
              }
              log(action.selected!, name: timeofString);
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
                  '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}';
              log(action.selected!, name: timeofString);

              if (action.selected == timeofString) {
                log('i ran when selected matched');
                store.dispatch(SelectTimeValuesActionSuccess(
                    selectedWeight: null,
                    selectedPressure: bloodPressureModel,
                    selected: null));
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
    } else {
      log('body weight');
      if (store.state.bodyweight!.length > 0) {
        store.state.bodyweight!.forEach((element) {
          MainWeightModelwithID initMainWeightModelwithID =
              MainWeightModelwithID.fromJson(element);
          MainBodyWeightModel initMainBodyWeightModel =
              MainBodyWeightModel.fromJson(initMainWeightModelwithID.data);
          String initSelectedDate =
              '${store.state.selectedDate!.day}-${store.state.selectedDate!.month}-${store.state.selectedDate!.year}';
          log(initSelectedDate);
          if (initMainBodyWeightModel.date_for == initSelectedDate) {
            log('match');
            initMainBodyWeightModel.readings!.forEach((element) {
              BodyWeightModel bodyWeightModel =
                  BodyWeightModel.fromJson(element);
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  bodyWeightModel.created_at);
              TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
              // log(timeOfDay.hour.toString());
              String timeofString =
                  '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}';
              log(action.selected!, name: timeofString);

              if (action.selected == timeofString) {
                log('i ran when selected matched');
                store.dispatch(SelectTimeValuesActionSuccess(
                    selectedWeight: bodyWeightModel,
                    selectedPressure: null,
                    selected: null));
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

void fetchUserRecords(Store<AppState> store, action, NextDispatcher next) {
  if (action is GetUserRecordsAction) {
    CollectionReference glucose = FirebaseFirestore.instance
        .collection('users')
        .doc(action.user_id)
        .collection('bloodglucose');
    glucose
        .orderBy('date_for_timestamp_millis', descending: true)
        .get()
        .then((value) {
      List<MainBloodGlucoseModel> initList = [];
      value.docs.forEach((element) {
        MainBloodGlucoseModel bloodGlucoseModel =
            MainBloodGlucoseModel.fromJson(element.data()!);
        initList.add(bloodGlucoseModel);
      });
      store.dispatch(GetGlucoseRecordsActionSuccess(glucoseRecords: initList));
    });
    CollectionReference pressure = FirebaseFirestore.instance
        .collection('users')
        .doc(action.user_id)
        .collection('bloodpressure');
    pressure
        .orderBy('date_for_timestamp_millis', descending: true)
        .get()
        .then((value) {
      List<MainBloodPressureModel> initList = [];
      value.docs.forEach((element) {
        MainBloodPressureModel bloodPressureModel =
            MainBloodPressureModel.fromJson(element.data()!);
        initList.add(bloodPressureModel);
      });
      store
          .dispatch(GetPressureRecordsActionSuccess(pressureRecords: initList));
    });
    CollectionReference weight = FirebaseFirestore.instance
        .collection('users')
        .doc(action.user_id)
        .collection('bodyweight');
    weight
        .orderBy('date_for_timestamp_millis', descending: true)
        .get()
        .then((value) {
      List<MainBodyWeightModel> initList = [];
      value.docs.forEach((element) {
        MainBodyWeightModel bodyWeightModel =
            MainBodyWeightModel.fromJson(element.data()!);
        initList.add(bodyWeightModel);
      });
      store.dispatch(GetWeightRecordsActionSuccess(weightRecords: initList));
    });
    log('users fetch done');
  }
  next(action);
}

void fetchChats(Store<AppState> store, action, NextDispatcher next) {
  if (action is ChatAction) {
    Query users = FirebaseFirestore.instance
        .collection('chats')
        .where('user_ids', arrayContains: action.user_id);
    Stream<QuerySnapshot> snapshot = users.snapshots();

    snapshot.listen((element) {
      MainChatsModel chatsModel = MainChatsModel();
      element.docs.forEach((e) {
        log('i ran');
        // UserModel userModel = UserModel.fromJson(e.data()!);
        // log(userModel.full_name, name: 'full name');

        chatsModel = MainChatsModel.fromJson(e.data()!);
        chatsModel.chats.sort((a, b) {
          ChatModel aMod = ChatModel.fromJson(a);
          ChatModel bMod = ChatModel.fromJson(b);
          return aMod.time_stamp - bMod.time_stamp;
        });
      });
      store.dispatch(ChatActionSuccess(mainChatsModel: chatsModel));
      // log('listener');
      // log(initialUsers.length.toString(), name: 'initial users');
    });
    // snapshot.single.then((value) => log(value.size.toString(),name: 'Streams'));

    log('users fetch done');
  } else if (action is UnreadAction) {
    Query users = FirebaseFirestore.instance
        .collection('chats')
        .where('rep_unread_count', isGreaterThan: 0);

    Stream<QuerySnapshot> snapshot = users.snapshots();

    snapshot.listen((element) {
      MainChatsModel chatsModel = MainChatsModel();
      List<UnreadModel> unreads = [];
      element.docs.forEach((e) {
        log('i unread ran', name: element.size.toString());
        // UserModel userModel = UserModel.fromJson(e.data()!);
        // log(userModel.full_name, name: 'full name');

        chatsModel = MainChatsModel.fromJson(e.data()!);
        unreads.add(UnreadModel(
            chat_id: chatsModel.chat_id!,
            rep_unread_count: chatsModel.rep_unread_count,
            user_ids: chatsModel.user_ids));
      });
      log(unreads.length.toString(), name: 'unreads Length');
      store.dispatch(UnreadActionSuccess(unreads: unreads));
      // log('listener');
      // log(initialUsers.length.toString(), name: 'initial users');
    });
  }
  next(action);
}
void fetchTips(Store<AppState> store, action, NextDispatcher next) {
  if (action is TipsAction) {
    Query tips = FirebaseFirestore.instance.collection('tips').orderBy('created_at',descending: true);
    Stream<QuerySnapshot> snapshot = tips.snapshots();

    snapshot.listen((element) {
      List<TipModel> initialTips = [];
      element.docs.forEach((e) {
        // log('i ran');
        TipModel tipModel = TipModel.fromJson(e.data()!);
        // log(userModel.full_name, name: 'full name');

        initialTips.add(tipModel);
      });
      store.dispatch(TipsActionSuccess(tips: initialTips));
      // log('listener');
      // log(initialTips.length.toString(), name: 'initial users');
    });
    // snapshot.single.then((value) => log(value.size.toString(),name: 'Streams'));

    log('users fetch done');
  }
  next(action);
}
void fetchUsers(Store<AppState> store, action, NextDispatcher next) {
  if (action is GetUsersAction) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Stream<QuerySnapshot> snapshot = users.snapshots();

    snapshot.listen((element) {
      List<UserModel> initialUsers = [];
      element.docs.forEach((e) {
        log('i ran');
        UserModel userModel = UserModel.fromJson(e.data()!);
        // log(userModel.full_name, name: 'full name');

        initialUsers.add(userModel);
      });
      store.dispatch(GetUsersActionSuccess(users: initialUsers));
      // log('listener');
      log(initialUsers.length.toString(), name: 'initial users');
    });
    // snapshot.single.then((value) => log(value.size.toString(),name: 'Streams'));

    log('users fetch done');
  }
  next(action);
}

void fetchWeight(Store<AppState> store, action, NextDispatcher next) {
  // If our Middleware encounters a `FetchTodoAction`
  if (action is GetWeightAction) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(action.user_id.length > 0
            ? action.user_id
            : store.state.userModel!.user_id)
        .collection('bodyweight');
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
        snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          log(documentSnapshot.id);
          items.add({
            'data': documentSnapshot.data(),
            'id': documentSnapshot.reference
          });
        });
        store.dispatch(GetWeightActionSuccess(
          weight: items,
        ));
      } else {
        store.dispatch(GetWeightActionSuccess(
          weight: items,
        ));
      }
      store.dispatch(SelectedDateAction(
          selected: store.state.selectedDate, screen: 'Body Weight'));
    });
    // store.dispatch(SelectedDateAction(selected: store.state.selectedDate));
  }

  // Make sure our actions continue on to the reducer.
  next(action);
}

void fetchPressure(Store<AppState> store, action, NextDispatcher next) {
  // If our Middleware encounters a `FetchTodoAction`
  if (action is GetPressureAction) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(action.user_id.length > 0
            ? action.user_id
            : store.state.userModel!.user_id)
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
      store.dispatch(SelectedDateAction(
          selected: store.state.selectedDate, screen: 'Blood Pressure'));
    });
    // store.dispatch(SelectedDateAction(selected: store.state.selectedDate));
  }

  // Make sure our actions continue on to the reducer.
  next(action);
}

void setDate(Store<AppState> store, action, NextDispatcher next) {
  if (action is SelectedDateAction) {
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
                '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}');
          });
        }
      });
    }
    if (action.screen == 'Blood Pressure' &&
        store.state.bloodpressure!.length > 0) {
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
                '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}');
          });
        }
      });
    }
    if (action.screen == 'Body Weight' && store.state.bodyweight!.length > 0) {
      store.state.bodyweight!.forEach((element) {
        MainWeightModelwithID initMainWeightModelwithID =
            MainWeightModelwithID.fromJson(element);
        MainBodyWeightModel initMainBodyWeightModel =
            MainBodyWeightModel.fromJson(initMainWeightModelwithID.data);
        String initSelectedDate =
            '${action.selected!.day}-${action.selected!.month}-${action.selected!.year}';
        if (initMainBodyWeightModel.date_for == initSelectedDate) {
          initMainBodyWeightModel.readings!.sort((a, b) {
            BloodGlucoseModel forA = BloodGlucoseModel.fromJson(a);
            BloodGlucoseModel forB = BloodGlucoseModel.fromJson(b);
            return forA.created_at - forB.created_at;
          });
          log(initMainBodyWeightModel.readings!.length.toString());
          initMainBodyWeightModel.readings!.forEach((element) {
            BodyWeightModel bodyWeightModel = BodyWeightModel.fromJson(element);
            DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(bodyWeightModel.created_at);
            TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
            // log(timeOfDay.hour.toString());
            selectedTimes.add(
                '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}');
          });
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
