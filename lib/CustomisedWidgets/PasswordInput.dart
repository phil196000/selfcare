import 'package:flutter/material.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

import 'RedText.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool passwordError;

  const PasswordInput({Key? key, required this.controller, required this.hint, required this.passwordError})
      : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscureText = true;
  DefaultColors defaultColors = DefaultColors();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RedText(text: widget.hint),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: TextField(
            controller: widget.controller,
            obscureText: this.obscureText,
            style: TextStyle(
                color: defaultColors.darkRed, fontWeight: FontWeight.bold),
            cursorColor: defaultColors.darkRed,
            decoration: InputDecoration(
                errorText: widget.passwordError &&
                        widget.controller.text.length < 8
                    ? 'Password must be 8 characters or more'
                    : widget.passwordError
                        ? 'Wrong password provided for user.'
                        : null,
                suffixIcon: IconButton(
                  color: defaultColors.primary,
                  icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => this.setState(() {
                    obscureText = !obscureText;
                  }),
                ),
                fillColor: defaultColors.white,
                filled: true,
                // hintText: "Enter Phone number",
                hintStyle: TextStyle(
                    color: defaultColors.darkRed,
                    fontWeight: FontWeight.normal),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: defaultColors.primary,
                        width: 2)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide:
                        BorderSide(color: defaultColors.primary, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: defaultColors.primary,
                        width: 2)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide:
                        BorderSide(color: defaultColors.primary, width: 2))),
          ),
        ),
      ],
    );
  }
}
