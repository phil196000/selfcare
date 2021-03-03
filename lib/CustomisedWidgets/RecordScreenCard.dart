import 'package:flutter/material.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

import 'WhiteText.dart';

class RecordScreenCard extends StatelessWidget {
  DefaultColors defaultColors = DefaultColors();
  final String value;
  final String unit;
  final Color background;
  final String poster;
  final String title;

  RecordScreenCard(
      {Key key,
      @required this.value,
      @required this.unit,
      this.background = Colors.red,
      this.poster = '',
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 5),
      decoration: BoxDecoration(
          color: this.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: defaultColors.white)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // this.poster,
          this.poster.length > 0
              ? Container(child: Image.asset(this.poster),margin: EdgeInsets.only(right: 5),)
              : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: WhiteText(
                  text: this.title,
                  weight: FontWeight.normal,
                ),
              ),
              Row(
                children: [
                  Container(
                    child: WhiteText(
                      text: this.value,
                      size: 30,
                    ),
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(bottom: 8),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        // left: 20,
                        ),
                    child: WhiteText(
                      text: this.unit,
                      size: 11,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
