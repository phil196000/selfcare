import 'package:flutter/material.dart';

class DefaultColors {
  final Color white;

  final Color primary;

  final Color darkblue;
  final Color darkRed;

  final Color green;
  final Color shadowColorGrey;
  final Color shadowColorRed;
  final Color black;

  DefaultColors(
      {this.shadowColorRed = const Color.fromRGBO(210, 0, 0, 0.3),
      this.shadowColorGrey = const Color.fromRGBO(0, 0, 0, 0.16),
      this.white = Colors.white,
      this.primary = const Color.fromRGBO(210, 0, 0, 1),
      this.darkblue = const Color.fromRGBO(27, 9, 115, 1),
      this.darkRed = const Color.fromRGBO(83, 5, 5, 1),
      this.green = const Color.fromRGBO(27, 126, 11, 1),
      this.black = Colors.black});
}
