import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/DefaultInput.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/Chats.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Screens/Chat/ChatCard.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/GetUserAction.dart';
import 'package:selfcare/redux/AppState.dart';

class ChatDialog extends StatefulWidget {
  final Function closeModal;
  final String option;
  final UserModel? userModel;
  final UserModel adminModel;

  ChatDialog(
      {required this.closeModal,
      this.option = 'Chat',
      this.userModel,
      required this.adminModel});

  @override
  _ChatDialogState createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  TextEditingController textEditingController = TextEditingController();
  DefaultColors defaultColors = DefaultColors();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('chats')
        .where('user_ids', arrayContains: widget.userModel!.user_id)
        .get()
        .then((value) {
      if (value.size > 0) {
        value.docs.forEach((element) {
          MainChatsModel mainChatsModel =
              MainChatsModel.fromJson(element.data()!);
          FirebaseFirestore.instance
              .collection('chats')
              .doc(mainChatsModel.chat_id)
              .update({'rep_unread_count': 0}).then((value) => log('updated'));
        });
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.adminModel.user_id)
        .update({'online': true}).then((value) => log('done and online'));
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.adminModel.user_id)
        .update({'online': false}).then((value) => log('done and offline'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext dupContext = context;
    return StoreConnector(
      builder: (context, AppState state) {
        log(state.userModelEdit!.full_name, name: 'user name');
        UserModel updateUserModelEdit = state.userModelEdit!;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.close), onPressed: () => widget.closeModal()),
            backgroundColor: DefaultColors().primary,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WhiteText(text: widget.userModel!.full_name),
                WhiteText(
                  text: widget.userModel!.online!=null ? 'Online' : 'Offline',
                  size: 12,
                  weight: FontWeight.normal,
                ),
              ],
            ),
            actions: [Icon(Icons.account_circle)],
          ),
          body:
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
            return Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                    flex: 14,
                    child: ListView(
                      children: [
                        if (state.chatsModel != null)
                          ...state.chatsModel!.chats.map((e) {
                            ChatModel chatModel = ChatModel.fromJson(e);
                            DateTime todayDate = DateTime.now();
                            DateTime yesterDay =
                                DateTime.fromMillisecondsSinceEpoch(
                                    todayDate.millisecondsSinceEpoch -
                                        24 * 3600 * 1000);
                            DateTime chatDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    chatModel.time_stamp);

                            bool show;
                            if (state.chatsModel!.chats.indexOf(e) != 0) {
                              DateTime previousDate =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      state.chatsModel!.chats[
                                          state.chatsModel!.chats.indexOf(e) -
                                              1]['time_stamp']);
                              if (chatDate.month == previousDate.month &&
                                  chatDate.day == previousDate.day &&
                                  chatDate.year == previousDate.year) {
                                show = false;
                              } else {
                                show = true;
                              }
                            } else {
                              show = true;
                            }

                            return Column(
                              children: [
                                Visibility(
                                  visible: show,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: WhiteText(
                                          text: chatDate.month ==
                                                      todayDate.month &&
                                                  chatDate.day ==
                                                      todayDate.day &&
                                                  chatDate.year ==
                                                      todayDate.year
                                              ? "Today"
                                              : chatDate.month ==
                                                          yesterDay.month &&
                                                      chatDate.day ==
                                                          yesterDay.day &&
                                                      chatDate.year ==
                                                          yesterDay.year
                                                  ? 'Yesterday'
                                                  : '${chatDate.day}/${chatDate.month}/${chatDate.year}',
                                          size: 12,
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 7),
                                        decoration: BoxDecoration(
                                            color: defaultColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: defaultColors
                                                      .shadowColorGrey,
                                                  offset: Offset(0, 5),
                                                  blurRadius: 10)
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                                ChatCard(
                                    time:
                                        '${chatDate.hour == 0 ? '12' : chatDate.hour > 12 ? chatDate.hour - 12 : chatDate.hour}:${chatDate.minute < 10 ? '0${chatDate.minute}' : chatDate.minute} ${chatDate.hour > 11 ? 'PM' : 'AM'}',
                                    from: chatModel.from ==
                                            state.userModel!.user_id
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    message: chatModel.message),
                              ],
                            );
                          }).toList(),
                      ],
                    )),
                Expanded(
                    flex: isKeyboardVisible ? 5 : 2,
                    child: Visibility(
                        visible: state.userModel!.user_id !=
                            widget.userModel!.user_id,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: TextField(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: textEditingController,
                                    style: TextStyle(
                                        color: defaultColors.darkRed,
                                        fontWeight: FontWeight.bold),
                                    cursorColor: defaultColors.darkRed,
                                    decoration: InputDecoration(
                                        filled: true,
                                        hintText: "Enter message",
                                        hintStyle: TextStyle(
                                            color: defaultColors.darkRed,
                                            fontWeight: FontWeight.normal),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide(
                                                style: BorderStyle.solid,
                                                color: defaultColors.primary,
                                                width: 2)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide(
                                                color: defaultColors.primary,
                                                width: 2)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide(
                                                style: BorderStyle.solid,
                                                color: defaultColors.primary,
                                                width: 2)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            borderSide: BorderSide(
                                                color: defaultColors.primary,
                                                width: 2))),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: IconButton(
                                  onPressed: () {
                                    if (textEditingController.text.length > 0) {
                                      DocumentReference docRef;
                                      MainChatsModel mainChatModel =
                                          state.chatsModel!;
                                      if (mainChatModel.chat_id != null) {
                                        docRef = FirebaseFirestore.instance
                                            .collection('chats')
                                            .doc(state.chatsModel!.chat_id);
                                        docRef.update({
                                          'chats': FieldValue.arrayUnion([
                                            {
                                              'time_stamp': DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              'message':
                                                  textEditingController.text,
                                              'from': state.userModel!.user_id,
                                            }
                                          ]),
                                          'user_unread_count':
                                              FieldValue.increment(1),
                                        }).then((value) {
                                          textEditingController.text = '';
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //         content: SnackBar(
                                          //   backgroundColor: Colors.green,
                                          //   content: Container(
                                          //     // color: Colors.yellow,
                                          //     child: WhiteText(
                                          //       text: 'Message sent Successfully',
                                          //     ),
                                          //   ),
                                          //   duration: Duration(milliseconds: 2000),
                                          // )));
                                        });
                                      } else {
                                        docRef = FirebaseFirestore.instance
                                            .collection('chats')
                                            .doc();
                                        docRef.set({
                                          'chat_id': docRef.id,
                                          'user_ids': FieldValue.arrayUnion([
                                            widget.userModel!.user_id,
                                            state.userModel!.user_id
                                          ]),
                                          'created_at': DateTime.now()
                                              .millisecondsSinceEpoch,
                                          'user_unread_count':
                                              FieldValue.increment(1),
                                          'rep_unread_count': 0,
                                          'chats': FieldValue.arrayUnion([
                                            {
                                              'time_stamp': DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              'message':
                                                  textEditingController.text,
                                              'from': state.userModel!.user_id,
                                            }
                                          ])
                                        }).then((value) {
                                          textEditingController.text = '';
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //         content: SnackBar(
                                          //   backgroundColor: Colors.green,
                                          //   content: Container(
                                          //     // color: Colors.yellow,
                                          //     child: WhiteText(
                                          //       text: 'Message sent Successfully',
                                          //     ),
                                          //   ),
                                          //   duration: Duration(milliseconds: 2000),
                                          // )));
                                        });
                                      }
                                      textEditingController.text = '';
                                    } else {
                                      log('i ran', name: 'send chat');
                                    }
                                  },
                                  icon: Icon(Icons.send),
                                ),
                              ))
                            ],
                          ),
                        )))
              ],
            );
          }),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
