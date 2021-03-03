import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/DefaultInput.dart';
import 'package:selfcare/CustomisedWidgets/PrimaryButton.dart';
import 'package:selfcare/CustomisedWidgets/TextButton.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DefaultColors defaultColors = DefaultColors();
  bool passwordVisibilty = true;

  @override
  Widget build(BuildContext context) {
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
                      flex: 6,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 26, horizontal: 22),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: defaultColors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 5),
                                  color: defaultColors.shadowColorGrey,
                                  blurRadius: 10)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DarkRedText(
                              text: 'Login to enjoy our services',
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: DefaultInput(
                                hint: 'Email',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: DefaultInput(
                                obscureText: passwordVisibilty,
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
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerRight,
                              child: PrimaryButton(
                                horizontalPadding: 50,
                                text: 'Login',
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      )),
                  Visibility(visible:!isKeyboardVisible,child: Spacer(flex: 2))
                ],
              )
            ],
          );
        },
      )),
    );
  }
}
