import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Screens/Record/HistoryCard1.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class History extends StatefulWidget {
  final String record;

  const History({Key key, this.record}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DefaultColors defaultColors = DefaultColors();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 100),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: WhiteText(
                text: '11 February 2021',
                size: 10,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                  color: defaultColors.darkRed,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: defaultColors.shadowColorGrey,
                        offset: Offset(0, 5),
                        blurRadius: 10)
                  ]),
            )
          ],
        ),
        HistoryCard1(
          showAvatars: widget.record == 'Blood Glucose' ? true : false,
          title: widget.record == 'Blood Glucose'
              ? ['Pre\nMeal', 'Post\nMeal']
              : ['Systolic', 'Diastolic'],
          time: '11',
          unit: widget.record == 'Blood Glucose' ? 'mg/dl' : 'mm/hg',
          values: ['329', '329'],
        ),
      ],
    );
  }
}
