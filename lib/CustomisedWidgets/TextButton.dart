import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';

class ButtonText extends StatelessWidget {
  final Function? onPressed;
  final String text;

  const ButtonText({Key? key, this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
        onPressed: ()=>this.onPressed,
        child: RedText(
          text: this.text,
          size: 14,
        ));
  }
}
