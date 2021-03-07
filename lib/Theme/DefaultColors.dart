import 'package:flutter/material.dart';

class DefaultColors {
  final Color white;

  final Color primary;
  final Color yellow;
  final Color darkblue;
  final Color darkRed;
  final Color lightdarkRed;
  final Color green;
  final Color shadowColorGrey;
  final Color shadowColorRed;
  final Color black;
  final Color grey;
  final Color cyan;

  DefaultColors(
      {this.cyan = const Color.fromRGBO(1, 129, 138, 1),
      this.grey = const Color.fromRGBO(101, 101, 101, 1),
      this.yellow = const Color.fromRGBO(148, 138, 8, 1),
      this.lightdarkRed = const Color.fromRGBO(83, 5, 5, 0.14),
      this.shadowColorRed = const Color.fromRGBO(210, 0, 0, 0.3),
      this.shadowColorGrey = const Color.fromRGBO(0, 0, 0, 0.16),
      this.white = Colors.white,
      this.primary = const Color.fromRGBO(210, 0, 0, 1),
      this.darkblue = const Color.fromRGBO(27, 9, 115, 1),
      this.darkRed = const Color.fromRGBO(83, 5, 5, 1),
      this.green = const Color.fromRGBO(27, 126, 11, 1),
      this.black = Colors.black});
}
