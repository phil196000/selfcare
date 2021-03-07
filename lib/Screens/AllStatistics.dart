import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

import 'Record/BarChart.dart';

class AllStatistics extends StatefulWidget {
  @override
  _AllStatisticsState createState() => _AllStatisticsState();
}

class _AllStatisticsState extends State<AllStatistics> {
  DefaultColors defaultColors = DefaultColors();
  String dropdownValue = 'One';

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
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: defaultColors.green,
                                ),
                                iconSize: 40,
                                onPressed: () {
                                  pushNewScreen(context,
                                      screen: Main(), withNavBar: false);
                                }),
                            DarkGreenText(text: 'ALL STATISTICS')
                          ],
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.help,
                              color: defaultColors.green,
                            ),
                            // iconSize: 40,
                            onPressed: () {})
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 13, left: 10, right: 10),
                    children: [
                      DarkGreenText(
                        text: 'Choose one or more to filter',
                        size: 13,
                      ),
                      Wrap(
                        spacing: 5,
                        children: [
                          FilterChip(
                            backgroundColor: Colors.transparent,
                            selectedColor: defaultColors.lightdarkRed,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: defaultColors.darkRed)),
                            labelStyle: TextStyle(color: defaultColors.darkRed),
                            selected: false,
                            onSelected: (bool selected) {
                              // this.setState(() {
                              //   choice = selected;
                              // });
                            },
                            label: Text('Blood Glucose'),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          FilterChip(
                            backgroundColor: Colors.transparent,
                            selectedColor: defaultColors.lightdarkRed,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: defaultColors.darkRed)),
                            labelStyle: TextStyle(color: defaultColors.darkRed),
                            selected: false,
                            onSelected: (bool selected) {
                              // this.setState(() {
                              //   choice = selected;
                              // });
                            },
                            label: Text('Blood Pressure'),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          FilterChip(
                            backgroundColor: Colors.transparent,
                            selectedColor: defaultColors.lightdarkRed,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: defaultColors.darkRed)),
                            labelStyle: TextStyle(color: defaultColors.darkRed),
                            selected: false,
                            onSelected: (bool selected) {
                              // this.setState(() {
                              //   choice = selected;
                              // });
                            },
                            label: Text('Body Weight'),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      DarkGreenText(
                        size: 13,
                        text: 'Pick duration',
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
                          items: <String>['One', 'Two', 'Free', 'Four']
                              .map<DropdownMenuItem<String>>((String value) {
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
                      Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: SimpleBarChart(
                          animate: true,
                        ),
                      )
                    ],
                  ),
                  flex: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
