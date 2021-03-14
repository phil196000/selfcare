import 'dart:developer';

import 'package:adobe_xd/pinned.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
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
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class Record extends StatefulWidget {
  final String title;

  const Record({required this.title});

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  DefaultColors defaultColors = DefaultColors();
  PageController pageController = PageController();
  int page = 0;
  bool choice = true;
  String dropdownValue = 'One';
  TextEditingController preMeal = TextEditingController(text: '0');

  TextEditingController postMeal = TextEditingController(text: '0');

  String date = '';
  String time = '';

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
          page = pageController.page!.toInt();
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

  String monthSelectedString(int m) {
    List<String> mo = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return mo[m];
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        DateTime selectedDate = state.selectedDate!;
        return Scaffold(
          appBar: AppBar(
            title: DarkRedText(text: widget.title.toUpperCase()),
            backgroundColor: defaultColors.white,
            leading: Builder(
              builder: (context) => IconButton(
                  icon: Icon(Icons.chevron_left),
                  color: defaultColors.darkRed,
                  iconSize: 40,
                  onPressed: () {
                    Navigator.pop(context);
                    // pushNewScreen(context,
                    //     screen: Main(), withNavBar: true);
                  }),
            ),
            actions: <Widget>[
              page == 0
                  ? IconButton(
                      icon: Icon(Icons.help),
                      onPressed: () {},
                      color: defaultColors.darkRed,
                    )
                  : Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.tune),
                          onPressed: () {},
                          color: defaultColors.darkRed,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {},
                          color: defaultColors.darkRed,
                        ),
                      ],
                    ),
            ],
          ),
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
                                            color:
                                                defaultColors.shadowColorGrey,
                                            offset: Offset(0, 5),
                                            blurRadius: 10)
                                      ]),
                                  margin: EdgeInsets.only(bottom: 25),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: DropdownButton<String>(
                                    value: dropdownValue,

                                    icon: Icon(
                                        Icons.keyboard_arrow_down_outlined),
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
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'One',
                                      'Two',
                                      'Free',
                                      'Four'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
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
                                        background:
                                            widget.title == 'Blood Glucose'
                                                ? defaultColors.darkRed
                                                : defaultColors.black,
                                        poster: widget.title == 'Blood Glucose'
                                            ? 'lib/Assets/emptybowl.png'
                                            : '',
                                      ),
                                      RecordScreenCard(
                                        textColor:
                                            widget.title == 'Blood Glucose'
                                                ? defaultColors.white
                                                : defaultColors.black,
                                        title: widget.title == 'Blood Glucose'
                                            ? 'Pre Meal'
                                            : 'Diastolic',
                                        value: '329',
                                        unit: widget.title == 'Blood Glucose'
                                            ? "mg/dl"
                                            : 'mm/hg',
                                        background:
                                            widget.title == 'Blood Glucose'
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
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05)
                                        : EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
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
                                              text: widget.title ==
                                                      'Blood Glucose'
                                                  ? "mg/dl"
                                                  : widget.title ==
                                                          'Bood Pressure'
                                                      ? 'mm/hg'
                                                      : 'kg',
                                              size: 12,
                                            ),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                      ),
                                      decoration: BoxDecoration(
                                          color: defaultColors.primary,
                                          border: Border.all(
                                              width: 2,
                                              color: defaultColors.white),
                                          boxShadow: [
                                            BoxShadow(
                                                color: defaultColors
                                                    .shadowColorGrey,
                                                offset: Offset(0, 5),
                                                blurRadius: 10)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 22, horizontal: 19),
                                      margin: EdgeInsets.only(
                                          right: 30, bottom: 15),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          side: BorderSide(
                                              color: defaultColors.darkRed)),
                                      labelStyle: TextStyle(
                                          color: defaultColors.darkRed),
                                      selected: choice,
                                      onSelected: (bool selected) {
                                        this.setState(() {
                                          choice = selected;
                                        });
                                      },
                                      label: Text('Calendar'),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    ChoiceChip(
                                      selected: !choice,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          side: BorderSide(
                                              color: defaultColors.darkRed)),
                                      labelStyle: TextStyle(
                                          color: defaultColors.darkRed),
                                      backgroundColor: defaultColors.white,
                                      selectedColor: defaultColors.lightdarkRed,
                                      onSelected: (bool selected) {
                                        this.setState(() {
                                          choice = !selected;
                                        });
                                      },
                                      label: Text('Graph'),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    )
                                  ],
                                ),
                                choice
                                    ? Container(
                                        child: Calendar(
                                        onDayPressed: (DateTime date,
                                            List<Event> events) {
                                          getIt.get<Store>().dispatch(
                                              SelectedDateAction(
                                                  selected: date));
                                        },
                                        selectedDate: selectedDate,
                                      ))
                                    : (widget.title == 'Blood Glucose' &&
                                                state.bloodglucose.length ==
                                                    0) ||
                                            (widget.title == 'Blood Pressure' &&
                                                state.bloodpressure.length ==
                                                    0) ||
                                            (widget.title == 'Body Weight' &&
                                                state.bodyweight.length == 0)
                                        ? RedText(
                                            text: 'No data avaible to be shown',
                                          )
                                        : Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: SimpleBarChart(
                                              animate: true,
                                            ),
                                          )
                              ],
                              padding: EdgeInsets.only(
                                  bottom: 100, top: 10, left: 15, right: 15),
                            ),
                            History(
                              record: widget.title,
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
                        decoration: BoxDecoration(
                            color: defaultColors.white,
                            boxShadow: [
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
                            return RecordSheet(
                              onSavePressed: () {
                                // log(state.userModel!.user_id.toString());
                                CollectionReference users = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(state.userModel!.user_id)
                                    .collection('bloodglucose');
                                // log('user id has to ran here',name: users.path);

                                users.add({
                                  'readings': [
                                    {
                                      'pre_meal': int.parse(preMeal.text),
                                      'post_meal': int.parse(postMeal.text),
                                      'created_at':
                                          DateTime.now().millisecondsSinceEpoch,
                                    }
                                  ],
                                  'date_for_timestamp_millis': state
                                      .selectedDate!.millisecondsSinceEpoch,
                                  'date_for':
                                      '${state.selectedDate!.day}-${state.selectedDate!.month}-${state.selectedDate!.year}',
                                }).then((value) => log('done'));
                              },
                              postMeal: postMeal,
                              preMeal: preMeal,
                              onPreMealMinusPressed: () {
                                int currentValue = int.parse(preMeal.text);
                                if (currentValue > 0) {
                                  currentValue -= 1;
                                }

                                preMeal.text = currentValue.toString();
                                // log(preMeal.text);
                              },
                              onPreMealAddPressed: () {
                                // log('pressed premeal');
                                int currentValue = int.parse(preMeal.text);
                                currentValue += 1;
                                preMeal.text = currentValue.toString();
                                // log(preMeal.text);
                              },
                              onPostMealAddPressed: () {
                                int currentValue = int.parse(postMeal.text);
                                currentValue += 1;
                                postMeal.text = currentValue.toString();
                              },
                              onPostMealMinusPressed: () {
                                int currentValue = int.parse(postMeal.text);
                                if (currentValue > 0) {
                                  currentValue -= 1;
                                }

                                postMeal.text = currentValue.toString();
                              },
                              onCancelPressed: () {
                                Navigator.pop(context);
                              },
                              timePressed: () async {
                                TimeOfDay? timeofday = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                log(timeofday!.hour.toString());
                                getIt.get<Store>().dispatch(SelectedDateAction(
                                        selected: DateTime(
                                      state.selectedDate!.year,
                                      state.selectedDate!.month,
                                      state.selectedDate!.day,
                                      timeofday.hour,
                                      timeofday.minute,
                                    )));
                              },
                              datePressed: () async {
                                DateTime? datetime = await showDatePicker(
                                    context: context,
                                    initialDate: state.selectedDate!,
                                    firstDate: DateTime(DateTime.now().year),
                                    lastDate: DateTime(
                                      DateTime.now().year + 1,
                                    ));
                                log(datetime!.year.toString());
                                getIt.get<Store>().dispatch(
                                    SelectedDateAction(selected: datetime));
                              },
                            );
                          });
                    },
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 21),
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
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}

/// Sample ordinal data type.

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
