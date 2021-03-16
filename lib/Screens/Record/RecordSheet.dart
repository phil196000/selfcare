import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/PrimaryButton.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/Screens/Record/AddRecordForm.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';
import 'package:selfcare/redux/AppState.dart';

import '../../main.dart';

class RecordSheet extends StatefulWidget {
  final TextEditingController preMeal;
  final String screen;
  final TextEditingController postMeal;

  final Function? onChangeDate;
  final Function? onPreMealMinusPressed;
  final Function? onPreMealAddPressed;
  final Function? onPostMealMinusPressed;
  final Function? onPostMealAddPressed;
  final Function? onCancelPressed;
  final Function? onSavePressed;

  final Function? datePressed;
  final Function? timePressed;

  RecordSheet({
    required this.preMeal,
    required this.postMeal,
    this.onChangeDate,
    this.datePressed,
    this.timePressed,
    this.onPreMealMinusPressed,
    this.onPreMealAddPressed,
    this.onPostMealMinusPressed,
    this.onPostMealAddPressed,
    this.onCancelPressed,
    this.onSavePressed,
    required this.screen,
  });

  @override
  _RecordSheetState createState() => _RecordSheetState();
}

class _RecordSheetState extends State<RecordSheet> {
  final DefaultColors defaultColors = DefaultColors();
  DateTime? dateTime;

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
                RedText(
                    text: widget.screen == 'Blood Glucose'
                        ? 'Pre Meal Or Post Meal values cannot be zero'
                        : widget.screen == 'Blood Pressure'
                            ? 'Systolic or Diastolic values cannot be zero'
                            : 'Weight'),
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
  void initState() {
    super.initState();
    setState(() {
      dateTime = getIt.get<Store<AppState>>().state.selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        DateTime selectedDate = state.selectedDate!;
        return SafeArea(
            child: KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) => Container(
                    height: isKeyboardVisible
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                        top: 20,
                        right: MediaQuery.of(context).size.width * 0.1),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Container(
                          height: 8,
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                              color: defaultColors.shadowColorGrey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.only(
                                right: 10,
                                left: 10,
                                top: 30,
                                bottom: isKeyboardVisible
                                    ? MediaQuery.of(context).size.height * 0.2
                                    : 20),
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                alignment: Alignment.center,
                                child: RedText(text: 'RECORD BLOOD GLUCOSE'),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RedText(
                                    text: 'Press text to change',
                                    weight: FontWeight.normal,
                                    size: 12,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            TimeOfDay? timeofday =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now());
                                            log(timeofday!.hour.toString());
                                            setState(() {
                                              dateTime = DateTime(
                                                state.selectedDate!.year,
                                                state.selectedDate!.month,
                                                state.selectedDate!.day,
                                                timeofday.hour,
                                                timeofday.minute,
                                              );
                                            });
                                            getIt
                                                .get<Store<AppState>>()
                                                .dispatch(SelectedDateAction(
                                                    screen: widget.screen,
                                                    selected: DateTime(
                                                      state.selectedDate!.year,
                                                      state.selectedDate!.month,
                                                      state.selectedDate!.day,
                                                      timeofday.hour,
                                                      timeofday.minute,
                                                    )));
                                          },
                                          child: DarkRedText(
                                            text:
                                                '${selectedDate.hour > 12 ? selectedDate.hour - 12 : selectedDate.hour == 0 ? 12 : selectedDate.hour}:${selectedDate.minute < 10 ? '0${selectedDate.minute}' : selectedDate.minute} ${selectedDate.hour >= 12 ? 'PM' : 'AM'}',
                                            size: 13,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // print('i am running');
                                            log(state.selectedDate!.day
                                                .toString());
                                            DateTime? datetimeNew =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        state.selectedDate!,
                                                    firstDate: DateTime(
                                                        DateTime.now().year),
                                                    lastDate: DateTime(
                                                      DateTime.now().year + 1,
                                                    ));
                                            log(datetimeNew!.year.toString());
                                            setState(() {
                                              dateTime = datetimeNew;
                                            });
                                            getIt
                                                .get<Store<AppState>>()
                                                .dispatch(SelectedDateAction(
                                                    screen: widget.screen,
                                                    selected: datetimeNew));
                                          },
                                          child: DarkRedText(
                                            text:
                                                '${selectedDate.day} ${monthSelectedString(selectedDate.month - 1)} ${selectedDate.year}',
                                            size: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              AddRecordForm(
                                avatar: widget.screen == "Blood Glucose",
                                key: Key('PreMealAddRecord1'),
                                title: widget.screen == "Blood Glucose"
                                    ? 'Pre Meal'
                                    : 'Systolic',
                                minusOnPressed: () =>
                                    widget.onPreMealMinusPressed!(),
                                addOnPressed: () =>
                                    widget.onPreMealAddPressed!(),
                                textEditingController: widget.preMeal,
                              ),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              AddRecordForm(
                                avatar: widget.screen == "Blood Glucose",
                                title: widget.screen == "Blood Glucose"
                                    ? 'Post Meal'
                                    : 'Diastolic',
                                minusOnPressed: () =>
                                    widget.onPostMealMinusPressed!(),
                                addOnPressed: () =>
                                    widget.onPostMealAddPressed!(),
                                textEditingController: widget.postMeal,
                                key: Key('PreMealAddRecord2'),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.08)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    onPressed: () => widget.onCancelPressed!(),
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 11),
                                      decoration: BoxDecoration(
                                          color: defaultColors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 1,
                                              color: defaultColors.primary)),
                                      child: RedText(text: 'Cancel'),
                                    ),
                                  ),
                                  PrimaryButton(
                                    verticalPadding: 12,
                                    text: 'Save',
                                    onPressed: () {
                                      log('${dateTime!.day}-${dateTime!.month}-${dateTime!.year}');
                                      int preMealVal =
                                          int.parse(widget.preMeal.text);
                                      int postMealVal =
                                          int.parse(widget.postMeal.text);
                                      if (widget.screen == 'Blood Glucose') {
                                        if (preMealVal > 0 && postMealVal > 0) {
                                          CollectionReference bloodglucose =
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(state.userModel!.user_id)
                                                  .collection('bloodglucose');
                                          // log('user id has to ran here',name: users.path);
                                          bloodglucose
                                              .where('date_for',
                                                  isEqualTo:
                                                      '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}')
                                              .get()
                                              .then((QuerySnapshot snapshot) {
                                            if (snapshot.docs.isEmpty) {
                                              bloodglucose.add({
                                                'readings': [
                                                  {
                                                    'pre_meal': int.parse(
                                                        widget.preMeal.text),
                                                    'post_meal': int.parse(
                                                        widget.postMeal.text),
                                                    'created_at': dateTime!
                                                        .millisecondsSinceEpoch,
                                                    'is_deleted': false,
                                                  }
                                                ],
                                                'is_deleted': false,
                                                'date_for_timestamp_millis':
                                                    dateTime!
                                                        .millisecondsSinceEpoch,
                                                'date_for':
                                                    '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}',
                                              }).then((value) => getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(
                                                      GetGlucoseAction()));
                                              getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(GetGlucoseAction());
                                              getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(SelectedDateAction(
                                                      screen: widget.screen,
                                                      selected: dateTime!));
                                            } else {
                                              bloodglucose
                                                  .doc(snapshot.docs[0].id)
                                                  .update({
                                                'readings':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'is_deleted': false,
                                                    'pre_meal': int.parse(
                                                        widget.preMeal.text),
                                                    'post_meal': int.parse(
                                                        widget.postMeal.text),
                                                    'created_at': dateTime!
                                                        .millisecondsSinceEpoch,
                                                  }
                                                ]),
                                              }).then((value) => getIt
                                                      .get<Store<AppState>>()
                                                      .dispatch(
                                                          GetGlucoseAction()));
                                              getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(GetGlucoseAction());
                                              getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(SelectedDateAction(
                                                      screen: widget.screen,
                                                      selected: dateTime!));
                                            }
                                            widget.preMeal.text = '0';
                                            widget.postMeal.text = '0';
                                            Navigator.pop(context);
                                          });
                                        } else {
                                          _showMyDialog();
                                        }
                                      }
                                      if (widget.screen == 'Blood Pressure') {
                                        if (preMealVal > 0 && postMealVal > 0) {
                                          CollectionReference bloodpressure =
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(state.userModel!.user_id)
                                                  .collection('bloodpressure');
                                          // log('user id has to ran here',name: users.path);
                                          bloodpressure
                                              .where('date_for',
                                                  isEqualTo:
                                                      '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}')
                                              .get()
                                              .then((QuerySnapshot snapshot) {
                                            if (snapshot.docs.isEmpty) {
                                              bloodpressure.add({
                                                'readings': [
                                                  {
                                                    'systolic': int.parse(
                                                        widget.preMeal.text),
                                                    'diastolic': int.parse(
                                                        widget.postMeal.text),
                                                    'created_at': dateTime!
                                                        .millisecondsSinceEpoch,
                                                    'is_deleted': false,
                                                  }
                                                ],
                                                'is_deleted': false,
                                                'date_for_timestamp_millis':
                                                    dateTime!
                                                        .millisecondsSinceEpoch,
                                                'date_for':
                                                    '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}',
                                              }).then((value) => getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(
                                                      GetPressureAction()));
                                              getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(
                                                      GetPressureAction());
                                              getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(SelectedDateAction(
                                                      screen: widget.screen,
                                                      selected: dateTime!));
                                            } else {
                                              bloodpressure
                                                  .doc(snapshot.docs[0].id)
                                                  .update({
                                                'readings':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'is_deleted': false,
                                                    'systolic': int.parse(
                                                        widget.preMeal.text),
                                                    'diastolic': int.parse(
                                                        widget.postMeal.text),
                                                    'created_at': dateTime!
                                                        .millisecondsSinceEpoch,
                                                  }
                                                ]),
                                              }).then((value) => getIt
                                                      .get<Store<AppState>>()
                                                      .dispatch(
                                                          GetPressureAction()));
                                              getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(
                                                      GetPressureAction());
                                              getIt
                                                  .get<Store<AppState>>()
                                                  .dispatch(SelectedDateAction(
                                                      screen: widget.screen,
                                                      selected: dateTime!));
                                            }
                                            widget.preMeal.text = '0';
                                            widget.postMeal.text = '0';
                                            Navigator.pop(context);
                                          });
                                        } else {
                                          _showMyDialog();
                                        }
                                      }

                                      // widget.onSavePressed!()
                                    },
                                    horizontalPadding: 25,
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ))));
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
