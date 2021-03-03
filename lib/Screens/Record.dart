import 'dart:developer';

import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/Legend.dart';
import 'package:selfcare/CustomisedWidgets/RecordScreenCard.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Screens/Record/RecordSheet.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class Record extends StatefulWidget {
  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  DefaultColors defaultColors = DefaultColors();
  PageController pageController = PageController();
  int page = 0;

  void changePage(int pageValue) {
    pageController.animateToPage(pageValue,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    this.setState(() {
      page = pageValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          // overflow: Overflow.visible,
          children: [
            Background(),

            Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: defaultColors.white, boxShadow: [
                      BoxShadow(
                          color: defaultColors.shadowColorGrey,
                          offset: Offset(0, 5),
                          blurRadius: 10)
                    ]),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.chevron_left),
                                iconSize: 40,
                                onPressed: () {}),
                            DarkRedText(text: 'BLOOD GLUCOSE')
                          ],
                        ),
                        page == 0
                            ? IconButton(
                                icon: Icon(Icons.help), onPressed: () {})
                            : Row(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.tune), onPressed: () {}),
                                  IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () {}),
                                ],
                              ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: PageView(
                      controller: pageController,
                      children: [
                        ListView(
                          children: [
                            DarkRedText(
                              size: 13,
                              text: 'Pick a time to view record',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RecordScreenCard(
                                  title: 'Pre Meal',
                                  value: '329',
                                  unit: "mg/dl",
                                  background: defaultColors.darkRed,
                                  poster: 'lib/Assets/emptybowl.png',
                                ),
                                RecordScreenCard(
                                  title: 'Pre Meal',
                                  value: '329',
                                  unit: "mg/dl",
                                  background: defaultColors.darkblue,
                                  poster: 'lib/Assets/fullbowl.png',
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: WhiteText(
                                          text: '329',
                                          size: 37,
                                        ),
                                      ),
                                      Container(
                                        child: WhiteText(
                                          text: 'mg/dl',
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                  ),
                                  decoration: BoxDecoration(
                                      color: defaultColors.primary,
                                      border: Border.all(
                                          width: 2, color: defaultColors.white),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                defaultColors.shadowColorGrey,
                                            offset: Offset(0, 5),
                                            blurRadius: 10)
                                      ],
                                      borderRadius: BorderRadius.circular(100)),
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 22, horizontal: 19),
                                  margin: EdgeInsets.only(right: 30),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Legend(
                                      text: 'High',
                                      color: defaultColors.primary,
                                    ),
                                    Legend(
                                      text: 'Normal',
                                      color: defaultColors.green,
                                    ),
                                    Legend(
                                      text: 'Low',
                                      color: Colors.yellow,
                                    )
                                  ],
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )
                          ],
                          padding: EdgeInsets.only(
                              bottom: 100, top: 10, left: 15, right: 15),
                        ),
                        ListView(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 100),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 7),
                                  decoration: BoxDecoration(
                                      color: defaultColors.darkRed,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                defaultColors.shadowColorGrey,
                                            offset: Offset(0, 5),
                                            blurRadius: 10)
                                      ]),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  flex: 12,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: defaultColors.white, boxShadow: [
                      BoxShadow(
                          color: defaultColors.shadowColorGrey,
                          offset: Offset(0, -5),
                          blurRadius: 10)
                    ]),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                            child: FlatButton(
                                onPressed: () => changePage(0),
                                padding: EdgeInsets.zero,
                                child: Container(
                                  alignment: Alignment.center,
                                  color: page == 0
                                      ? defaultColors.shadowColorRed
                                      : defaultColors.white,
                                  child: RedText(text: 'Main'),
                                ))),
                        Expanded(
                            child: FlatButton(
                                onPressed: () => changePage(1),
                                padding: EdgeInsets.zero,
                                child: Container(
                                  alignment: Alignment.center,
                                  color: page == 1
                                      ? defaultColors.shadowColorRed
                                      : defaultColors.white,
                                  child: RedText(text: 'History'),
                                ))),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              child: RaisedButton(
                onPressed: () {
                  log('message of the enter value');
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      enableDrag: false,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return RecordSheet();
                      });
                },
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 21),
                  decoration: BoxDecoration(
                      color: defaultColors.primary,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            color: defaultColors.shadowColorRed,
                            offset: Offset(0, 5),
                            blurRadius: 6)
                      ],
                      border: Border.all(
                          width: 1,
                          color: defaultColors.white,
                          style: BorderStyle.solid)),
                  child: Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.add,
                          color: defaultColors.white,
                        ),
                      ),
                      Text(
                        'Enter Value',
                        style: TextStyle(
                          color: defaultColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              right: 10,
              bottom: MediaQuery.of(context).size.height * 0.07 + 7,
            ),
          ],
        ),
      ),
    );
  }
}
