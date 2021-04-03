import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';

import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/Legend.dart';
import 'package:selfcare/CustomisedWidgets/RecordScreenCard.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/Record/BarChart.dart';
import 'package:selfcare/Screens/Record/Calendar.dart';
import 'package:selfcare/Screens/Record/History.dart';
import 'package:selfcare/Screens/Record/RecordSheet.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/GetBodyWeightAction.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:charts_flutter/flutter.dart' as charts;

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
  String? dropdownValue;

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
    getIt.get<Store<AppState>>().dispatch(GetGlucoseAction());
    getIt.get<Store<AppState>>().dispatch(GetPressureAction());
    getIt.get<Store<AppState>>().dispatch(GetWeightAction());
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

  String firstCard(
      {BloodGlucoseModel? bloodGlucoseModel,
      BloodPressureModel? bloodPressureModel}) {
    if (widget.title == 'Blood Glucose') {
      return bloodGlucoseModel!.pre_meal.toString();
    }
    return bloodPressureModel!.systolic.toString();
  }

  String secondCard(
      {BloodGlucoseModel? bloodGlucoseModel,
      BloodPressureModel? bloodPressureModel}) {
    if (widget.title == 'Blood Glucose') {
      return bloodGlucoseModel!.post_meal.toString();
    }
    return bloodPressureModel!.diastolic.toString();
  }

  String averageCard(
      {required BloodGlucoseModel bloodGlucoseModel,
      required BloodPressureModel bloodPressureModel,
      required BodyWeightModel bodyWeightModel}) {
    if (widget.title == 'Blood Glucose' &&
        bloodGlucoseModel.post_meal != null) {
      return ((bloodGlucoseModel.pre_meal + bloodGlucoseModel.post_meal) / 2)
          .toStringAsFixed(1);
    } else if (widget.title == 'Blood Pressure') {
      return ((bloodPressureModel.systolic + bloodPressureModel.diastolic) / 2)
          .toStringAsFixed(1);
    } else if (widget.title == 'Body Weight') {
      return bodyWeightModel.weight.toStringAsFixed(1);
    }
    return '';
  }

  List<charts.Series<GraphModel, String>> graphList(
      {BloodGlucoseModel? bloodGlucoseModel,
      BloodPressureModel? bloodPressureModel,
      BodyWeightModel? bodyWeightModel}) {
    final data = widget.title == 'Blood Glucose'
        ? [
            new GraphModel('Pre Meal', bloodGlucoseModel!.pre_meal),
            new GraphModel('Post Meal', bloodGlucoseModel.post_meal)
          ]
        : widget.title == 'Blood Pressure'
            ? [
                new GraphModel('Systolic', bloodPressureModel!.systolic),
                new GraphModel('Diastolic', bloodPressureModel.diastolic)
              ]
            : <GraphModel>[new GraphModel('Weight', bodyWeightModel!.weight)];

    return [
      new charts.Series<GraphModel, String>(
        id: widget.title,
        labelAccessorFn: (datum, index) => datum.value.toString(),
        colorFn: (GraphModel datum, index) {
          return widget.title == 'Blood Glucose'
              ? datum.title == 'Pre Meal'
                  ? charts.Color.fromHex(code: '#530505')
                  : charts.Color.fromHex(code: '#1B0973')
              : widget.title == 'Blood Pressure'
                  ? datum.title == 'Systolic'
                      ? charts.Color.fromHex(code: '#000000')
                      : charts.Color.fromHex(code: '#FFFFFF')
                  : datum.title == 'Weight'
                      ? charts.Color.fromHex(code: '#FF0000')
                      : charts.Color.fromHex(code: '#1B0973');
        },
        domainFn: (GraphModel graphmodel, _) => graphmodel.title,
        measureFn: (GraphModel graphmodel, _) => graphmodel.value,
        data: data,
      )
    ];
  }

  Future<void> _deleteAll(
      {required String user_id, required String collection}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('DELETE ALL')],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RedText(
                    text: 'You are about to delete ALL ITEMS in your history'),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: DarkRedText(
                    text: 'Do you want to proceed to Delete?',
                    weight: FontWeight.normal,
                    size: 14,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: RedText(
                text: 'NO',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: DarkGreenText(
                text: 'YES',
              ),
              onPressed: () {
                CollectionReference ref = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user_id)
                    .collection(collection);
                ref.get().then((QuerySnapshot snapshot) {
                  snapshot.docs.forEach((element) {
                    MainGlucoseModelwithID mainbloodGlucoseModelwithID =
                        MainGlucoseModelwithID(
                            data: element.data(), id: element.reference);
                    mainbloodGlucoseModelwithID.id!.delete().then((value) {
                      getIt
                          .get<Store<AppState>>()
                          .dispatch(GetPressureAction());
                      getIt.get<Store<AppState>>().dispatch(GetGlucoseAction());
                      getIt.get<Store<AppState>>().dispatch(GetWeightAction());
                    });
                    if (snapshot.size == snapshot.docs.indexOf(element)) {
                      log('i ran');
                      getIt.get<Store<AppState>>().dispatch(GetGlucoseAction());
                      getIt
                          .get<Store<AppState>>()
                          .dispatch(GetPressureAction());
                      getIt.get<Store<AppState>>().dispatch(GetWeightAction());
                    }
                  });
                });
                getIt.get<Store<AppState>>().dispatch(GetGlucoseAction());
                getIt.get<Store<AppState>>().dispatch(GetPressureAction());
                getIt.get<Store<AppState>>().dispatch(GetWeightAction());

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Alert')],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RedText(text: 'Pre Meal Or Post Meal values cannot be zero'),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: DarkRedText(
                    text: 'Press OK to make changes and save again',
                    weight: FontWeight.normal,
                    size: 14,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Main(),
                        ),
                        (route) => false);
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
                        // IconButton(
                        //   icon: Icon(Icons.tune),
                        //   onPressed: () {},
                        //   color: defaultColors.darkRed,
                        // ),
                        IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: (widget.title == 'Blood Glucose' &&
                                  state.bloodglucose!.length > 0)
                              ? () {
                                  _deleteAll(
                                      user_id: state.userModel!.user_id,
                                      collection: 'bloodglucose');
                                }
                              : (widget.title == 'Blood Pressure' &&
                                      state.bloodpressure!.length > 0)
                                  ? () {
                                      _deleteAll(
                                          user_id: state.userModel!.user_id,
                                          collection: 'bloodpressure');
                                    }
                                  : (widget.title == 'Body Weight' &&
                                          state.bodyweight!.length > 0)
                                      ? () {
                                          _deleteAll(
                                              user_id: state.userModel!.user_id,
                                              collection: 'bodyweight');
                                        }
                                      : null,
                          color: defaultColors.primary,
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
                                      getIt.get<Store<AppState>>().dispatch(
                                          SelectTimeValuesAction(
                                              screen: widget.title,
                                              selected: newValue));
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: state.selectedDateTimes!
                                        .map<DropdownMenuItem<String>>(
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
                                  visible: widget.title != 'Body Weight' &&
                                      dropdownValue != null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RecordScreenCard(
                                        textColor: defaultColors.white,
                                        title: widget.title == 'Blood Glucose'
                                            ? 'Pre Meal'
                                            : 'Systolic',
                                        value: firstCard(
                                            bloodGlucoseModel:
                                                state.selectTimeValues!,
                                            bloodPressureModel:
                                                state.selectTimeValuesPressure),
                                        unit: widget.title == 'Blood Glucose'
                                            ? "mmol/L"
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
                                            ? 'Post Meal'
                                            : 'Diastolic',
                                        value: secondCard(
                                            bloodPressureModel:
                                                state.selectTimeValuesPressure,
                                            bloodGlucoseModel:
                                                state.selectTimeValues!),
                                        unit: widget.title == 'Blood Glucose'
                                            ? "mmol/L"
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
                                Visibility(
                                  visible: dropdownValue != null,
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: WhiteText(
                                                text: averageCard(
                                                    bodyWeightModel: state
                                                        .selectTimeValuesWeight!,
                                                    bloodGlucoseModel:
                                                        state.selectTimeValues!,
                                                    bloodPressureModel: state
                                                        .selectTimeValuesPressure!),
                                                size: 37,
                                              ),
                                            ),
                                            Container(
                                              child: WhiteText(
                                                text: widget.title ==
                                                        'Blood Glucose'
                                                    ? "mmol/L"
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
                                ),
                                Row(
                                  children: [
                                    ChoiceChip(
                                      backgroundColor: defaultColors.lightdarkRed,
                                      selectedColor: defaultColors.white,
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
                                      backgroundColor: defaultColors.lightdarkRed,
                                      selectedColor: defaultColors.white,
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
                                          setState(() {
                                            dropdownValue = null;
                                          });
                                          getIt.get<Store<AppState>>().dispatch(
                                              SelectedDateAction(
                                                  screen: widget.title,
                                                  selected: date));
                                        },
                                        selectedDate: selectedDate,
                                        screen: widget.title,
                                      ))
                                    : dropdownValue == null
                                        ? RedText(
                                            text: 'No data avaible to be shown',
                                          )
                                        : (widget.title == 'Blood Glucose' &&
                                                    state.bloodglucose!
                                                            .length ==
                                                        0) ||
                                                (widget.title ==
                                                        'Blood Pressure' &&
                                                    state.bloodpressure!
                                                            .length ==
                                                        0) ||
                                                (widget.title ==
                                                        'Body Weight' &&
                                                    state.bodyweight!.length ==
                                                        0)
                                            ? RedText(
                                                text:
                                                    'No data avaible to be shown',
                                              )
                                            : Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                child: SimpleBarChart(
                                                    animate: true,
                                                    seriesList: graphList(
                                                        bodyWeightModel: state
                                                            .selectTimeValuesWeight!,
                                                        bloodGlucoseModel: state
                                                            .selectTimeValues!,
                                                        bloodPressureModel: state
                                                            .selectTimeValuesPressure)),
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
                              screen: widget.title,
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
                                getIt
                                    .get<Store<AppState>>()
                                    .dispatch(SelectedDateAction(
                                        screen: widget.title,
                                        selected: DateTime(
                                          state.selectedDate!.year,
                                          state.selectedDate!.month,
                                          state.selectedDate!.day,
                                          timeofday.hour,
                                          timeofday.minute,
                                        )));
                              },
                              datePressed: () async {
                                print('i am running');
                                log(state.selectedDate!.day.toString());
                                DateTime? datetime = await showDatePicker(
                                    context: context,
                                    initialDate: state.selectedDate!,
                                    firstDate: DateTime(DateTime.now().year),
                                    lastDate: DateTime(
                                      DateTime.now().year + 1,
                                    ));
                                log(datetime!.year.toString());

                                getIt.get<Store<AppState>>().dispatch(
                                    SelectedDateAction(
                                        selected: datetime,
                                        screen: widget.title));
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

class GraphModel {
  final String? title;
  final double? value;

  GraphModel(this.title, this.value);
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
