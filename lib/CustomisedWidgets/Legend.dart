import 'package:flutter/material.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

import 'DarkBlueText.dart';

class Legend extends StatelessWidget {
  final String text;
  final Color color;

  const Legend({Key? key, required this.text, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 21,
            height: 15,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: this.color,
              boxShadow: [
                BoxShadow(
                  color:
                  DefaultColors().shadowColorGrey,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          DarkBlueText(text: this.text)
        ],
      ),
    );
  }
}
