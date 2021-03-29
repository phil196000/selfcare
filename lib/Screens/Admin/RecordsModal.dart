import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/DefaultInput.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/TextButton.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/Screens/Record/HistoryCard1.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/GetUserAction.dart';
import 'package:selfcare/redux/AppState.dart';

import '../Record.dart';

class RecordsDialog extends StatefulWidget {
  final Function closeModal;
  final String option;
  final UserModel? userModel;

  RecordsDialog(
      {required this.closeModal, this.option = 'Add', this.userModel});

  @override
  _RecordsDialogState createState() => _RecordsDialogState();
}

class _RecordsDialogState extends State<RecordsDialog> {
//Page View
  late PageController pageController;
  int page = 0;
  DefaultColors defaultColors = DefaultColors();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        log(state.userModelEdit!.full_name, name: 'user name');
        UserModel updateUserModelEdit = state.userModelEdit!;
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => widget.closeModal()),
              backgroundColor: DefaultColors().green,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WhiteText(text: 'Records'),
                  WhiteText(
                    text: '${state.userModelEdit!.full_name}',
                    size: 14,
                    weight: FontWeight.normal,
                  )
                ],
              ),
            ),
            body: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: ButtonText(
                          text: 'Glucose',
                          onPressed: () {
                            pageController.animateToPage(0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                        ),
                        color: page == 0
                            ? DefaultColors().shadowColorRed
                            : Colors.transparent,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ButtonText(
                          text: 'Pressure',
                          onPressed: () {
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                        ),
                        color: page == 1
                            ? DefaultColors().shadowColorRed
                            : Colors.transparent,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ButtonText(
                          text: 'Weight',
                          onPressed: () {
                            pageController.animateToPage(2,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                        ),
                        color: page == 2
                            ? DefaultColors().shadowColorRed
                            : Colors.transparent,
                      ),
                    ),
                  ],
                )),
                Expanded(
                    flex: 12,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (int p) {
                        setState(() {
                          page = p;
                        });
                      },
                      children: [
                        ListView(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 100),
                          children: [
                            Visibility(
                                visible: state.glucoseRecords.length == 0,
                                child: RedText(
                                  text:
                                      'No records yet',
                                )),

                            ...state.glucoseRecords.map((e) {
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      e.date_for_timestamp_millis!);
                              return Visibility(
                                  visible: !e.is_deleted,
                                  child: Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      Visibility(
                                          visible: e.readings!.length > 0 &&
                                              !e.is_deleted,
                                          child: Row(
                                            key: Key(
                                                '${e.date_for_timestamp_millis}'),
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
                                                    color:
                                                        defaultColors.darkRed,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
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
                                      ...e.readings!.map((e) {
                                        BloodGlucoseModel bloodglucoseModel =
                                            BloodGlucoseModel.fromJson(e);
                                        TimeOfDay timeOfDay =
                                            TimeOfDay.fromDateTime(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    bloodglucoseModel
                                                        .created_at));

                                        return Visibility(
                                            visible:
                                                !bloodglucoseModel.is_deleted,
                                            child: HistoryCard1(
                                              showDelete: false,
                                              // delete: () {
                                              //   _singleDelete(
                                              //     e: e,
                                              //     modelwithID: initMainGlucoseModelwithID,
                                              //   );
                                              //   // log(initMainGlucoseModelwithID.id.toString());
                                              // },
                                              key: Key(bloodglucoseModel
                                                  .created_at
                                                  .toString()),
                                              showAvatars:
                                                  page == 0 ? true : false,
                                              title: page == 0
                                                  ? ['Pre\nMeal', 'Post\nMeal']
                                                  : ['Systolic', 'Diastolic'],
                                              time:
                                                  '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}',
                                              unit:
                                                  page == 1 ? 'mg/dl' : 'mm/hg',
                                              values: [
                                                bloodglucoseModel.pre_meal
                                                    .toString(),
                                                bloodglucoseModel.post_meal
                                                    .toString()
                                              ],
                                              delete: () => null,
                                            ));
                                      })
                                    ],
                                  ));
                            }).toList(),
                          ],
                        ),
                        ListView(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 100),
                          children: [
                            Visibility(
                                visible:
                                    state.pressureRecords.length == 0,
                                child: RedText(
                                  text:
                                      'No records yet',
                                )),
                            ...state.pressureRecords.map((e) {
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      e.date_for_timestamp_millis!);
                              return Visibility(
                                  visible: !e.is_deleted,
                                  child: Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      Visibility(
                                          visible: e.readings!.length > 0 &&
                                              !e.is_deleted,
                                          child: Row(
                                            key: Key(
                                                '${e.date_for_timestamp_millis}'),
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
                                                    color:
                                                        defaultColors.darkRed,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
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
                                      ...e.readings!.map((e) {
                                        BloodPressureModel bloodpressureModel =
                                            BloodPressureModel.fromJson(e);
                                        TimeOfDay timeOfDay =
                                            TimeOfDay.fromDateTime(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    bloodpressureModel
                                                        .created_at));

                                        return Visibility(
                                            visible:
                                                !bloodpressureModel.is_deleted,
                                            child: HistoryCard1(
                                              showDelete: false,
                                              delete: () {
                                                // _singleDelete(
                                                //     e: e,
                                                //     pressureModelwithID:
                                                //     initMainPressureModelwithID);
                                                // log(initMainGlucoseModelwithID.id.toString());
                                              },
                                              key: Key(bloodpressureModel
                                                  .created_at
                                                  .toString()),
                                              showAvatars:
                                                  page == 1 ? true : false,
                                              title: page == 1
                                                  ? ['Pre\nMeal', 'Post\nMeal']
                                                  : ['Systolic', 'Diastolic'],
                                              time:
                                                  '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}',
                                              unit:
                                                  page == 1 ? 'mg/dl' : 'mm/hg',
                                              values: [
                                                bloodpressureModel.systolic
                                                    .toString(),
                                                bloodpressureModel.diastolic
                                                    .toString()
                                              ],
                                            ));
                                      })
                                    ],
                                  ));
                            }).toList(),
                          ],
                        ),
                        ListView(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 100),
                          children: [
                            Visibility(
                                visible: state.weightRecords.length == 0,
                                child: RedText(
                                  text:
                                      'No records yet',
                                )),
                            ...state.weightRecords.map((e) {
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      e.date_for_timestamp_millis!);
                              return Visibility(
                                  visible: !e.is_deleted,
                                  child: Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      Visibility(
                                          visible: e.readings!.length > 0 &&
                                              !e.is_deleted,
                                          child: Row(
                                            key: Key(
                                                '${e.date_for_timestamp_millis}'),
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
                                                    color:
                                                        defaultColors.darkRed,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
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
                                      ...e.readings!.map((e) {
                                        BodyWeightModel bodyWeighteModel =
                                            BodyWeightModel.fromJson(e);
                                        TimeOfDay timeOfDay =
                                            TimeOfDay.fromDateTime(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    bodyWeighteModel
                                                        .created_at));

                                        return Visibility(
                                            visible:
                                                !bodyWeighteModel.is_deleted,
                                            child: HistoryCard1(
                                              showDelete: false,
                                              delete: () {
                                                // log(initMainGlucoseModelwithID.id.toString());
                                              },
                                              key: Key(bodyWeighteModel
                                                  .created_at
                                                  .toString()),
                                              showAvatars:
                                                  page == 2 ? true : false,
                                              title: page == 2
                                                  ? ['Pre\nMeal', 'Post\nMeal']
                                                  : ['Systolic', 'Diastolic'],
                                              time:
                                                  '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}',
                                              unit: page == 2
                                                  ? 'mg/dl'
                                                  : page == 2
                                                      ? 'mm/hg'
                                                      : 'kg',
                                              values: [
                                                bodyWeighteModel.weight
                                                    .toString(),
                                                bodyWeighteModel.weight
                                                    .toString()
                                              ],
                                            ));
                                      })
                                    ],
                                  ));
                            }).toList(),
                          ],
                        )
                      ],
                    ))
              ],
            ));
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
