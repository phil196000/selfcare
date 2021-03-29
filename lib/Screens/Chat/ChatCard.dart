import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class ChatCard extends StatelessWidget {
  final MainAxisAlignment from;
  final String message;
  final String time;

  ChatCard({required this.from, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: from,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: DefaultColors().shadowColorGrey,
                    offset: Offset(0, 5),
                    blurRadius: 10)
              ],
              borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(from == MainAxisAlignment.end ? 10 : 0),
                  topRight: Radius.circular(
                      from == MainAxisAlignment.start ? 10 : 0)),
              color: from == MainAxisAlignment.end
                  ? DefaultColors().darkblue
                  : DefaultColors().darkRed),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                WhiteText(
                  size: 16,
                  weight: FontWeight.normal,
                  text: message,
                ),
                SizedBox(
                  height: 3,
                ),
                WhiteText(
                  text: time,
                  size: 8,
                  weight: FontWeight.normal,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
