import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/Screens/Record.dart';
import 'package:selfcare/Screens/Record/HistoryCard1.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';
import 'package:selfcare/redux/AppState.dart';

import '../../main.dart';

class History extends StatefulWidget {
  final String record;

  const History({required this.record});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DefaultColors defaultColors = DefaultColors();

  Future<void> _singleDelete(
      {MainGlucoseModelwithID? modelwithID,
      dynamic e,
      MainPressureModelwithID? pressureModelwithID}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('DELETE SINGLE')],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RedText(text: 'You are about to delete this item'),
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
                DocumentReference itemRef = (widget.record == 'Blood Glucose'
                    ? modelwithID!.id!
                    : pressureModelwithID!.id)!;
                itemRef.update({
                  'readings': FieldValue.arrayRemove([e])
                }).then((value) => widget.record == 'Blood Glucose'
                    ? getIt.get<Store<AppState>>().dispatch(GetGlucoseAction())
                    : getIt
                        .get<Store<AppState>>()
                        .dispatch(GetPressureAction()));
                // itemRef.update({
                //   'readings': FieldValue.arrayUnion([
                //     {
                //       'pre_meal': bloodGlucoseModel.pre_meal,
                //       'post_meal': bloodGlucoseModel.post_meal,
                //       'created_at': bloodGlucoseModel.created_at,
                //       'is_deleted': !bloodGlucoseModel.is_deleted,
                //     }
                //   ])
                // }).then((value) => null);
                widget.record == 'Blood Glucose'
                    ? getIt.get<Store<AppState>>().dispatch(GetGlucoseAction())
                    : getIt
                        .get<Store<AppState>>()
                        .dispatch(GetPressureAction());
                Navigator.pop(context);
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
        return widget.record == 'Blood Glucose'
            ? ListView(
                padding:
                    EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 100),
                children: [
                  Visibility(
                      visible: state.bloodglucose!.length == 0,
                      child: RedText(
                        text: 'No records yet, add your first reading',
                      )),
                  ...state.bloodglucose!.map((e) {
                    MainGlucoseModelwithID initMainGlucoseModelwithID =
                        MainGlucoseModelwithID.fromJson(e);

                    MainBloodGlucoseModel mainbloodGlucoseModel =
                        MainBloodGlucoseModel.fromJson(
                            initMainGlucoseModelwithID.data);
                    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                        mainbloodGlucoseModel.date_for_timestamp_millis!);
                    return Visibility(
                        visible: !mainbloodGlucoseModel.is_deleted,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Visibility(
                                visible:
                                    mainbloodGlucoseModel.readings!.length >
                                            0 &&
                                        !mainbloodGlucoseModel.is_deleted,
                                child: Row(
                                  key: Key(
                                      '${mainbloodGlucoseModel.date_for_timestamp_millis}'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: WhiteText(
                                        text:
                                            '${dateTime.day} ${monthSelectedString(dateTime.month - 1)} ${dateTime.year}',
                                        size: 10,
                                      ),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 7),
                                      decoration: BoxDecoration(
                                          color: defaultColors.darkRed,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                color: defaultColors
                                                    .shadowColorGrey,
                                                offset: Offset(0, 5),
                                                blurRadius: 10)
                                          ]),
                                    )
                                  ],
                                )),
                            ...mainbloodGlucoseModel.readings!.map((e) {
                              BloodGlucoseModel bloodglucoseModel =
                                  BloodGlucoseModel.fromJson(e);
                              TimeOfDay timeOfDay = TimeOfDay.fromDateTime(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      bloodglucoseModel.created_at));

                              return Visibility(
                                  visible: !bloodglucoseModel.is_deleted,
                                  child: HistoryCard1(
                                    delete: () {
                                      _singleDelete(
                                        e: e,
                                        modelwithID: initMainGlucoseModelwithID,
                                      );
                                      // log(initMainGlucoseModelwithID.id.toString());
                                    },
                                    key: Key(bloodglucoseModel.created_at
                                        .toString()),
                                    showAvatars:
                                        widget.record == 'Blood Glucose'
                                            ? true
                                            : false,
                                    title: widget.record == 'Blood Glucose'
                                        ? ['Pre\nMeal', 'Post\nMeal']
                                        : ['Systolic', 'Diastolic'],
                                    time:
                                        '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}',
                                    unit: widget.record == 'Blood Glucose'
                                        ? 'mg/dl'
                                        : 'mm/hg',
                                    values: [
                                      bloodglucoseModel.pre_meal.toString(),
                                      bloodglucoseModel.post_meal.toString()
                                    ],
                                  ));
                            })
                          ],
                        ));
                  }).toList(),
                ],
              )
            : widget.record == 'Blood Pressure'
                ? ListView(
                    padding: EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 100),
                    children: [
                      Visibility(
                          visible: state.bloodpressure!.length == 0,
                          child: RedText(
                            text: 'No records yet, add your first reading',
                          )),
                      ...state.bloodpressure!.map((e) {
                        MainPressureModelwithID initMainPressureModelwithID =
                            MainPressureModelwithID.fromJson(e);

                        MainBloodPressureModel mainbloodPressureModel =
                            MainBloodPressureModel.fromJson(
                                initMainPressureModelwithID.data);
                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                            mainbloodPressureModel.date_for_timestamp_millis!);
                        return Visibility(
                            visible: !mainbloodPressureModel.is_deleted,
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Visibility(
                                    visible: mainbloodPressureModel
                                                .readings!.length >
                                            0 &&
                                        !mainbloodPressureModel.is_deleted,
                                    child: Row(
                                      key: Key(
                                          '${mainbloodPressureModel.date_for_timestamp_millis}'),
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: WhiteText(
                                            text:
                                                '${dateTime.day} ${monthSelectedString(dateTime.month - 1)} ${dateTime.year}',
                                            size: 10,
                                          ),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 7),
                                          decoration: BoxDecoration(
                                              color: defaultColors.darkRed,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: defaultColors
                                                        .shadowColorGrey,
                                                    offset: Offset(0, 5),
                                                    blurRadius: 10)
                                              ]),
                                        )
                                      ],
                                    )),
                                ...mainbloodPressureModel.readings!.map((e) {
                                  BloodPressureModel bloodpressureModel =
                                      BloodPressureModel.fromJson(e);
                                  TimeOfDay timeOfDay = TimeOfDay.fromDateTime(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          bloodpressureModel.created_at));

                                  return Visibility(
                                      visible: !bloodpressureModel.is_deleted,
                                      child: HistoryCard1(
                                        delete: () {
                                          _singleDelete(
                                              e: e,
                                              pressureModelwithID:
                                                  initMainPressureModelwithID);
                                          // log(initMainGlucoseModelwithID.id.toString());
                                        },
                                        key: Key(bloodpressureModel.created_at
                                            .toString()),
                                        showAvatars:
                                            widget.record == 'Blood Glucose'
                                                ? true
                                                : false,
                                        title: widget.record == 'Blood Glucose'
                                            ? ['Pre\nMeal', 'Post\nMeal']
                                            : ['Systolic', 'Diastolic'],
                                        time:
                                            '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}',
                                        unit: widget.record == 'Blood Glucose'
                                            ? 'mg/dl'
                                            : 'mm/hg',
                                        values: [
                                          bloodpressureModel.systolic.toString(),
                                          bloodpressureModel.diastolic.toString()
                                        ],
                                      ));
                                })
                              ],
                            ));
                      }).toList(),
                    ],
                  )
                : Container();
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
