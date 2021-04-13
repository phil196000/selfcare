import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class PrimaryButton extends StatelessWidget {
  final DefaultColors defaultColors = DefaultColors();
  final String text;
  final Function? onPressed;
  final double horizontalPadding;
  final double verticalPadding;

  PrimaryButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.horizontalPadding = 15,
      this.verticalPadding = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => this.onPressed!(),
        style: ButtonStyle(
            padding: MaterialStateProperty.resolveWith((states) =>
                EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: this.horizontalPadding)),
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => defaultColors.primary),
            side: MaterialStateProperty.resolveWith((states) => BorderSide(
                width: 1,
                color: defaultColors.white,
                style: BorderStyle.solid))),
        child: WhiteText(
          text: this.text,
        ));
    return RaisedButton(
      onPressed: () => this.onPressed!(),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: this.horizontalPadding),
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
