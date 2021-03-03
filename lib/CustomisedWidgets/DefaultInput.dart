import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class DefaultInput extends StatelessWidget {
  DefaultColors defaultColors = DefaultColors();
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
   DefaultInput({Key key, this.controller,@required this.hint, this.obscureText=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RedText(text: this.hint),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: TextField(
            controller: this.controller,
            obscureText: this.obscureText,
            style: TextStyle(

                color: defaultColors.darkRed, fontWeight: FontWeight.bold),
            cursorColor: defaultColors.darkRed,
            decoration: InputDecoration(
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
