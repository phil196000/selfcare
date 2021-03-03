import 'package:flutter/material.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class PrimaryButton extends StatelessWidget {
  DefaultColors defaultColors = DefaultColors();
  final String text;
  final Function onPressed;
  final double horizontalPadding;

  PrimaryButton(
      {Key key, this.text, this.onPressed, this.horizontalPadding = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.onPressed,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 15, horizontal: this.horizontalPadding),
        decoration: BoxDecoration(
            color: defaultColors.primary,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: defaultColors.shadowColorRed,
                  offset: Offset(0, 5),
                  blurRadius: 6)
            ],
            border: Border.all(
                width: 1,
                color: defaultColors.white,
                style: BorderStyle.solid)),
        child: Text(
          this.text,
          style: TextStyle(
            color: defaultColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
