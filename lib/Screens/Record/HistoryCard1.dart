import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class HistoryCard1 extends StatelessWidget {
  final DefaultColors defaultColors = DefaultColors();
  final List title;
  final List values;
  final String unit;
  final String time;
  final Function delete;
  final bool showAvatars;

  HistoryCard1(
      {required Key key,
      required this.title,
      required this.values,
      required this.unit,
      required this.time,
      required this.delete,
      this.showAvatars = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: defaultColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: defaultColors.shadowColorGrey,
                blurRadius: 10,
                offset: Offset(0, 5))
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DarkRedText(
                text: '11:50 AM',
                size: 14,
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.delete_forever),
                  onPressed: () => null)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Visibility(
                          visible: showAvatars,
                          child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: defaultColors.darkRed,
                                  borderRadius: BorderRadius.circular(5)),
                              child: title[0] == 'Pre\nMeal'
                                  ? Image.asset('lib/Assets/emptybowl.png')
                                  : Image.asset('lib/Assets/fullbowl.png')),
                        ),
                        DarkRedText(
                          text: title[0],
                          size: 14,
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      DarkRedText(
                        text: values[0],
                        size: 24,
                      ),
                      DarkRedText(
                        text: unit,
                        size: 11,
                        weight: FontWeight.normal,
                      )
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Visibility(
                          visible: showAvatars,
                          child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: defaultColors.darkRed,
                                  borderRadius: BorderRadius.circular(5)),
                              child: title[1] == 'Post\nMeal'
                                  ? Image.asset('lib/Assets/emptybowl.png')
                                  : Image.asset('lib/Assets/fullbowl.png')),
                        ),
                        DarkRedText(
                          text: title[1],
                          size: 14,
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      DarkRedText(
                        text: values[1],
                        size: 24,
                      ),
                      DarkRedText(
                        text: unit,
                        size: 11,
                        weight: FontWeight.normal,
                      )
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
