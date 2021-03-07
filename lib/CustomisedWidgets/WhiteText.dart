import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class WhiteText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;

  const WhiteText(
      {Key key,
      @required this.text,
      this.size = 16,
      this.weight = FontWeight.bold,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
        fontFamily: 'Segoe UI',
        fontSize: this.size,
        color: color,
        fontWeight: this.weight,
      ),
      textAlign: TextAlign.left,
    );
  }
}
