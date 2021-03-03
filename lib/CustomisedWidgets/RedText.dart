import 'package:flutter/material.dart';

class RedText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;

  const RedText(
      {Key key,
      @required this.text,
      this.size = 16,
      this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
        fontFamily: 'Segoe UI',
        fontSize: this.size,
        color: const Color(0xffd20000),
        fontWeight: this.weight,
      ),
      textAlign: TextAlign.left,
    );
  }
}
