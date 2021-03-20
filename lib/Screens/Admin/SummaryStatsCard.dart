import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class SummaryStatsCard extends StatelessWidget {
  final String value;
  final String title;

  SummaryStatsCard({this.value='', this.title=''});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: DefaultColors().darkblue,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: DefaultColors().shadowColorGrey,
                offset: Offset(0, 5),
                blurRadius: 10)
          ]),
      child: Column(
        children: [
          WhiteText(
            text: value,
            size: 22,
          ),
          WhiteText(
            text: title,
            size: 12,
          )
        ],
      ),
    );
  }
}
