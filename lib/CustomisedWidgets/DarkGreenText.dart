import 'package:flutter/material.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class DarkGreenText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final double size;
  const DarkGreenText({Key? key, required this.text, this.weight=FontWeight.bold, this.size =18}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(

        fontSize: this.size,
        color: DefaultColors().green,
        fontWeight: this.weight,
      ),
      textAlign: TextAlign.left,
    );
  }
}
