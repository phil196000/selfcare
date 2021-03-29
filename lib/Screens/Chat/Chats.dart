import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/Chats.dart';
import 'package:selfcare/Screens/Chat/ChatCard.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';

class Chats extends StatefulWidget {
  final String? user_id;

  Chats({this.user_id});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  TextEditingController textEditingController = TextEditingController();
  DefaultColors defaultColors = DefaultColors();
   ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('chats')
        .where('user_ids', arrayContains: widget.user_id)
        .get()
        .then((value) {
      if (value.size > 0) {
        value.docs.forEach((element) {
          MainChatsModel mainChatsModel =
              MainChatsModel.fromJson(element.data()!);
          FirebaseFirestore.instance
              .collection('chats')
              .doc(mainChatsModel.chat_id)
              .update({'user_unread_count': 0}).then((value) => log('updated'));
        });
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user_id)
        .update({'online': true}).then((value) => log('done and online'));
    // scrollController = ScrollController();
    // scrollController.animateTo(offset, duration: duration, curve: curve)
    if(scrollController.hasClients)
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user_id)
        .update({'online': false}).then((value) => log('done and offline'));
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: DefaultColors().primary,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WhiteText(text: 'Representative'),
                WhiteText(
                  text: 'Online',
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
                      controller: scrollController,
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
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: TextField(
                                onTap: () {
                                  scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 300));
                                },
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
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: defaultColors.primary,
                                            width: 2)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            color: defaultColors.primary,
                                            width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: defaultColors.primary,
                                            width: 2)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
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
                                          'message': textEditingController.text,
                                          'from': state.userModel!.user_id,
                                        }
                                      ]),
                                      'rep_unread_count':
                                          FieldValue.increment(1),
                                    }).then((value) {
                                      textEditingController.text = '';
                                    });
                                  } else {
                                    docRef = FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc();
                                    docRef.set({
                                      'chat_id': docRef.id,
                                      'user_ids': FieldValue.arrayUnion(
                                          [state.userModel!.user_id]),
                                      'created_at':
                                          DateTime.now().millisecondsSinceEpoch,
                                      'chats': FieldValue.arrayUnion([
                                        {
                                          'time_stamp': DateTime.now()
                                              .millisecondsSinceEpoch,
                                          'message': textEditingController.text,
                                          'from': state.userModel!.user_id,
                                        }
                                      ]),
                                      'rep_unread_count': 1,
                                      'user_unread_count': 0
                                    }).then((value) {
                                      textEditingController.text = '';
                                    });
                                  }
                                  textEditingController.text = '';
                                  scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 300));
                                } else {}
                              },
                              icon: Icon(Icons.send),
                            ),
                          ))
                        ],
                      ),
                    ))
              ],
            );
          }),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
