import 'dart:developer';

import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/Legend.dart';
import 'package:selfcare/CustomisedWidgets/RecordScreenCard.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/Record/BarChart.dart';
import 'package:selfcare/Screens/Record/Calendar.dart';
import 'package:selfcare/Screens/Record/DropDown.dart';
import 'package:selfcare/Screens/Record/History.dart';
import 'package:selfcare/Screens/Record/RecordSheet.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class Record extends StatefulWidget {
  final String title;

  const Record({Key key, this.title}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  DefaultColors defaultColors = DefaultColors();
  PageController pageController = PageController();
  int page = 0;
  bool choice = true;
  String dropdownValue = 'One';

  void changePage(int pageValue) {
    pageController.animateToPage(pageValue,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    this.setState(() {
      page = pageValue;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      // log(pageController.page.toString());
      if (pageController.page == 0.0 || pageController.page == 1.0) {
        this.setState(() {
          page = pageController.page.toInt();
        });
        log(pageController.page.toString());
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
                                onPressed: () {
                                  Navigator.pop(context);
                                  // pushNewScreen(context,
                                  //     screen: Main(), withNavBar: true);
                                }),
                            DarkRedText(text: widget.title.toUpperCase())
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
                            Container(
                              decoration: BoxDecoration(
                                  color: defaultColors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: defaultColors.darkblue,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: defaultColors.shadowColorGrey,
                                        offset: Offset(0, 5),
                                        blurRadius: 10)
                                  ]),
                              margin: EdgeInsets.only(bottom: 25),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                value: dropdownValue,

                                icon: Icon(Icons.keyboard_arrow_down_outlined),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,

                                hint: Text('Select a text'),
                                style: TextStyle(color: Colors.deepPurple),
                                // selectedItemBuilder: ,
                                underline: Container(
                                  height: 0,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <String>[
                                  'One',
                                  'Two',
                                  'Free',
                                  'Four'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: defaultColors.darkblue,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Visibility(
                              visible: widget.title != 'Body Weight',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RecordScreenCard(
                                    textColor: defaultColors.white,
                                    title: widget.title == 'Blood Glucose'
                                        ? 'Pre Meal'
                                        : 'Systolic',
                                    value: '329',
                                    unit: widget.title == 'Blood Glucose'
                                        ? "mg/dl"
                                        : 'mm/hg',
                                    background: widget.title == 'Blood Glucose'
                                        ? defaultColors.darkRed
                                        : defaultColors.black,
                                    poster: widget.title == 'Blood Glucose'
                                        ? 'lib/Assets/emptybowl.png'
                                        : '',
                                  ),
                                  RecordScreenCard(
                                    textColor: widget.title == 'Blood Glucose'
                                        ? defaultColors.white
                                        : defaultColors.black,
                                    title: widget.title == 'Blood Glucose'
                                        ? 'Pre Meal'
                                        : 'Diastolic',
                                    value: '329',
                                    unit: widget.title == 'Blood Glucose'
                                        ? "mg/dl"
                                        : 'mm/hg',
                                    background: widget.title == 'Blood Glucose'
                                        ? defaultColors.darkblue
                                        : defaultColors.white,
                                    poster: widget.title == 'Blood Glucose'
                                        ? 'lib/Assets/fullbowl.png'
                                        : '',
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: widget.title != 'Body Weight'
                                    ? EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.05)
                                    : EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.002)),
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
                                          text: widget.title == 'Blood Glucose'
                                              ? "mg/dl"
                                              : widget.title == 'Bood Pressure'
                                                  ? 'mm/hg'
                                                  : 'kg',
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
                                  margin:
                                      EdgeInsets.only(right: 30, bottom: 15),
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
                            ),
                            Row(
                              children: [
                                ChoiceChip(
                                  backgroundColor: Colors.transparent,
                                  selectedColor: defaultColors.lightdarkRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: defaultColors.darkRed)),
                                  labelStyle:
                                      TextStyle(color: defaultColors.darkRed),
                                  selected: choice,
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      choice = selected;
                                    });
                                  },
                                  label: Text('Calendar'),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                ChoiceChip(
                                  selected: !choice,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: defaultColors.darkRed)),
                                  labelStyle:
                                      TextStyle(color: defaultColors.darkRed),
                                  backgroundColor: defaultColors.white,
                                  selectedColor: defaultColors.lightdarkRed,
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      choice = !selected;
                                    });
                                  },
                                  label: Text('Graph'),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                )
                              ],
                            ),
                            choice
                                ? Container(child: Calendar())
                                : Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: SimpleBarChart(
                                      animate: true,
                                    ),
                                  )
                          ],
                          padding: EdgeInsets.only(
                              bottom: 100, top: 10, left: 15, right: 15),
                        ),
                        History(record: widget.title,)
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
                      enableDrag: true,
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

/// Sample ordinal data type.

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
