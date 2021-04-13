import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/Chats.dart';
import 'package:selfcare/Data/RecordsModel.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/Screens/Admin/ChatModal.dart';
import 'package:selfcare/Screens/Admin/SummaryStatsCard.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/ChatActions.dart';
import 'package:selfcare/redux/Actions/GetRecordsAction.dart';
import 'package:selfcare/redux/Actions/GetUserAction.dart';
import 'package:selfcare/redux/Actions/GetUsersAction.dart';
import 'package:selfcare/redux/Actions/RatingsAction.dart';
import 'package:selfcare/redux/Actions/TipsAction.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login.dart';
import 'RecordsModal.dart';
import 'UserModal.dart';

class AdminHome extends StatefulWidget {
  final Function? hidenavbar;

  AdminHome({this.hidenavbar});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String? dropdownValue;

  // UserModel? userModelEdit;
  void messageInteraction() async {
    // Get any messages which caused the application to open from
    // a terminated state.

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      log('i ran', name: 'opened the app');
      // log(value!.notification!.body!.toString(), name: 'opened the app');
      // if (value!.data['type'] == 'chat') {
      //   // Navigator.pushNamed(context, '/chat',
      //   //     arguments: ChatArguments(initialMessage));
      // }
    });

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(message.notification!.body!, name: 'App in background');
      // if (message.data['type'] == 'chat') {
      //   // Navigator.pushNamed(context, '/chat',
      //   //     arguments: ChatArguments(message));
      // }
    });
  }

  @override
  void initState() {
    super.initState();
    getIt.get<Store<AppState>>().dispatch(GetUsersAction());
    getIt.get<Store<AppState>>().dispatch(UnreadAction());
    getIt.get<Store<AppState>>().dispatch(TipsAction());
    getIt.get<Store<AppState>>().dispatch(RatingsAction());
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('i ran notification ');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    });
    messageInteraction();
  }

  void openChatDialog(
      {String option = 'Chat',
      UserModel? userModelEdit,
      UserModel? adminModel}) {
    widget.hidenavbar!(true);
    // log('pressed');
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatDialog(
          adminModel: adminModel!,
          userModel: userModelEdit,
          option: option,
          closeModal: () {
            getIt
                .get<Store<AppState>>()
                .dispatch(ChatActionSuccess(mainChatsModel: MainChatsModel()));

            widget.hidenavbar!(false);
            Navigator.pop(context);
            setState(() {
              dropdownValue = null;
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void openRecordsDialog({
    String option = 'Record',
    UserModel? userModelEdit,
  }) {
    widget.hidenavbar!(true);
    // log('pressed');
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => RecordsDialog(
          userModel: userModelEdit,
          option: option,
          closeModal: () {
            getIt
                .get<Store<AppState>>()
                .dispatch(GetUserEditAction(userEditModel: UserModel()));
            getIt.get<Store<AppState>>().dispatch(
                GetGlucoseRecordsActionSuccess(
                    glucoseRecords: <MainBloodGlucoseModel>[]));
            getIt.get<Store<AppState>>().dispatch(
                GetPressureRecordsActionSuccess(
                    pressureRecords: <MainBloodPressureModel>[]));
            getIt.get<Store<AppState>>().dispatch(GetWeightRecordsActionSuccess(
                weightRecords: <MainBodyWeightModel>[]));
            widget.hidenavbar!(false);
            Navigator.pop(context);
            setState(() {
              dropdownValue = null;
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void openUserModal({
    String option = 'Add',
    UserModel? userModelEdit,
  }) {
    widget.hidenavbar!(true);
    // log('pressed');
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => UserFormDialog(
          userModel: userModelEdit,
          option: option,
          closeModal: () {
            widget.hidenavbar!(false);
            Navigator.pop(context);
            setState(() {
              dropdownValue = null;
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _logout() async {
    final SharedPreferences prefs = await _prefs;
    // final String counter = (prefs.getString('email') ?? 'Hello');

    prefs.clear().then((value) {
      this.widget.hidenavbar!(true);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return Login();
        },
      ), (route) => false);
    });
  }

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

  String unreadValue(
      {required List<UnreadModel> unreadList, required UserModel usMod}) {
    String valueToReturn = '0';
    unreadList.forEach((element) {
      if (element.user_ids!.contains(usMod.user_id)) {
        valueToReturn = element.rep_unread_count.toString();
      }
    });
    return valueToReturn;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        int usersCount = 0;
        int adminCount = 0;
        state.users!.forEach((element) {
          if (element.roles.contains('USER')) {
            usersCount += 1;
          }
          if (element.roles.contains('ADMIN')) {
            adminCount += 1;
          }
        });
        return Scaffold(
          body: SafeArea(
              child: Stack(
            children: [
              Background(),
              Positioned.fill(
                  child: ListView(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DarkRedText(
                            text: 'Hello',
                            size: 12,
                          ),
                          DarkRedText(text: 'Admin'),
                        ],
                      ),
                      IconButton(
                          color: DefaultColors().primary,
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            logout();
                          })
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  RedText(
                    text: 'Summary Stats for all users',
                    size: 14,
                  ),
                  Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      SummaryStatsCard(
                        title: 'Overall',
                        value: state.users!.length.toString(),
                      ),
                      SummaryStatsCard(
                        title: 'Users',
                        value: usersCount.toString(),
                      ),
                      SummaryStatsCard(
                        title: 'Admin',
                        value: adminCount.toString(),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  RedText(
                    text: 'Users',
                  ),
                  ...state.users!.map((e) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Visibility(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.verified_user,
                                  color: DefaultColors().green,
                                ),
                                DarkRedText(
                                  text: 'Current',
                                  size: 10,
                                )
                              ],
                            ),
                            visible: e.user_id == state.userModel!.user_id,
                          ),
                          title: Text(e.full_name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.roles.toString()),
                              e.is_active
                                  ? DarkGreenText(
                                      text: 'Active',
                                      size: 10,
                                    )
                                  : DarkRedText(
                                      text: 'InActive',
                                      size: 10,
                                    )
                            ],
                          ),

                          // leading: Icon(Icons.label),
                          trailing: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Stack(
                              children: [
                                Visibility(
                                    visible: (e.user_id !=
                                            state.userModel!.user_id) &&
                                        state.unreadList.length != 0 &&
                                        unreadValue(
                                                unreadList: state.unreadList,
                                                usMod: e) !=
                                            '0',
                                    child: Stack(
                                      // overflow: Overflow.visible,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Icon(
                                          Icons.chat,
                                          color: DefaultColors().primary,
                                        ),
                                        Positioned(
                                            right: 0,
                                            top: -5,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 3),
                                              decoration: BoxDecoration(
                                                  color: DefaultColors().green,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: DefaultColors()
                                                            .shadowColorGrey,
                                                        offset: Offset(0, 5),
                                                        blurRadius: 10)
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: WhiteText(
                                                size: 8,
                                                text: unreadValue(
                                                    unreadList:
                                                        state.unreadList,
                                                    usMod: e),
                                              ),
                                            ))
                                      ],
                                    )),
                                DropdownButton<String>(
                                  icon: Icon(Icons.more_vert),
                                  value: null,

                                  // isExpanded: false,

                                  underline: Container(
                                    height: 0,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  items: <DropdownMenuItem<String>>[
                                    DropdownMenuItem(
                                      value: 'Edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          Text('Edit')
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Record',
                                      child: Row(
                                        children: [
                                          Icon(Icons.file_copy),
                                          Text('View Record')
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Chat',
                                      child: Row(
                                        children: [
                                          Icon(Icons.chat),
                                          Text('Chat')
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_forever),
                                          Text('Delete User')
                                        ],
                                      ),
                                    )
                                  ],
                                  onChanged: (value) {
                                    log(value.toString());
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                    if (value == 'Record') {
                                      getIt.get<Store<AppState>>().dispatch(
                                          GetUserEditAction(userEditModel: e));
                                      getIt.get<Store<AppState>>().dispatch(
                                          GetUserRecordsAction(
                                              user_id: e.user_id));
                                      openRecordsDialog(
                                          option: 'Record', userModelEdit: e);
                                    } else if (value == 'Chat') {
                                      getIt.get<Store<AppState>>().dispatch(
                                          GetUserEditAction(userEditModel: e));
                                      getIt.get<Store<AppState>>().dispatch(
                                          ChatAction(user_id: e.user_id));
                                      openChatDialog(
                                          option: 'Chat',
                                          userModelEdit: e,
                                          adminModel: state.userModel);
                                    } else if (value == 'Edit') {
                                      getIt.get<Store<AppState>>().dispatch(
                                          GetUserEditAction(userEditModel: e));
                                      openUserModal(
                                          option: 'Edit', userModelEdit: e);
                                    } else if (value == 'Delete' &&
                                        e.user_id != state.userModel!.user_id) {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [Text('Delete')],
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  RedText(
                                                      text:
                                                          'You are about to delete this account'),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 15),
                                                    child: DarkRedText(
                                                      text:
                                                          'Do you want to proceed?',
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
                                                onPressed: () async {
                                                  try {
                                                    UserCredential userCred =
                                                        await FirebaseAuth
                                                            .instance
                                                            .signInWithEmailAndPassword(
                                                                email: e.email,
                                                                password:
                                                                    e.password);
                                                    if (userCred.user != null) {
                                                      userCred.user!
                                                          .delete()
                                                          .then((value) {
                                                        DocumentReference user =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(e.user_id);
                                                        user
                                                            .delete()
                                                            .then((value) {});
                                                        Navigator.pop(context);
                                                      });
                                                    }
                                                  } on FirebaseAuthException catch (ex) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      // onVisible: () => Timer(
                                                      //     Duration(seconds: 2),
                                                      //         () => Navigator.of(context).pop()),
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Container(
                                                        // color: Colors.yellow,
                                                        child: WhiteText(
                                                          text: ex.code,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 2000),
                                                    ));
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        // onVisible: () => Timer(
                                        //     Duration(seconds: 2),
                                        //         () => Navigator.of(context).pop()),
                                        backgroundColor: Colors.red,
                                        content: Container(
                                          // color: Colors.yellow,
                                          child: WhiteText(
                                            text:
                                                'Current user cannot be deleted, sign in with different account to delete this user',
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 2000),
                                      ));
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: DefaultColors().shadowColorGrey,
                        )
                      ],
                    );
                  }).toList(),
                ],
              )),
              Positioned(
                  bottom: 60,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      openUserModal(userModelEdit: state.userModel);
                    },
                    child: Icon(Icons.add),
                  )),
            ],
          )),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
