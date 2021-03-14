import 'package:flutter/material.dart';

class DarkRedText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final double size;

  const DarkRedText(
      {Key? key,
      required this.text,
      this.weight = FontWeight.bold,
      this.size = 18})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
        fontFamily: 'Segoe UI',
        fontSize: this.size,
        color: const Color(0xff530505),
        fontWeight: this.weight,
      ),
      textAlign: TextAlign.left,
    );
  }
}
