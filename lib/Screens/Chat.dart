import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/ChatAsset.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Screens/Chat/Chats.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';

class Chat extends StatefulWidget {
  final Function? hidenavbar;

  Chat({this.hidenavbar});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController textEditingController = TextEditingController();
  DefaultColors defaultColors = DefaultColors();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    // myFocusNode.addListener(() {
    //   if (myFocusNode.hasFocus) {
    //     widget.hidenavbar!(true);
    //   } else {
    //     widget.hidenavbar!(false);
    //   }
    // });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        return Scaffold(
          body: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return Center(
                child: Visibility(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ChatImageAsset(),
                    ),
                    DarkRedText(text: 'Chat with our representative'),
                    TextButton(
                      onPressed: () {
                        pushNewScreen(context,
                            screen: Chats(
                              user_id: state.userModel!.user_id,
                            ),
                            withNavBar: false);
                      },
                      child: RedText(
                        text: 'Move to chat',
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => DefaultColors().shadowColorRed)),
                    )
                  ],
                )),
              );
            },
          ),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
