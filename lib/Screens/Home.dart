import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RecentCard.dart';
import 'package:selfcare/CustomisedWidgets/RecordCard.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/RecordCardModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/Screens/AllStatistics.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/TipsAction.dart';
import 'package:selfcare/redux/AppState.dart';

import 'Record.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List recentRecording = [
  {'value': 128, 'unit': 'mg/dl'}
];

class _HomeState extends State<Home> {
  DefaultColors defaultColors = DefaultColors();

  @override
  void initState() {
    super.initState();
    // log('home ran');
    getIt.get<Store<AppState>>().dispatch(TipsAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        List<BloodGlucoseModel> glucoseSort = [];
        List<BloodPressureModel> pressureSort = [];
        List<BodyWeightModel> weightSort = [];
        String date = '';
        if (state.tips.length > 0) {
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(state.tips[0].created_at);
          date =
              '${dateTime.day} ${monthSelectedString(dateTime.month - 1)} ${dateTime.year} at ${dateTime.hour == 0 ? '12' : dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${dateTime.hour > 11 ? 'PM' : 'AM'}';
        }
        if (state.bloodglucose!.length > 0) {
          state.bloodglucose!.forEach((element) {
            MainGlucoseModelwithID mainGlucoseModelwithID =
                MainGlucoseModelwithID.fromJson(element);
            MainBloodGlucoseModel mainBloodGlucoseModel =
                MainBloodGlucoseModel.fromJson(mainGlucoseModelwithID.data);
            // List<BloodGlucoseModel> glucoseSort = [];
            mainBloodGlucoseModel.readings!.forEach((element) {
              BloodGlucoseModel bloodGlucoseModel =
                  BloodGlucoseModel.fromJson(element);
              glucoseSort.add(bloodGlucoseModel);
            });
          });

          // log(glucoseSort.length.toString(), name: 'length');
          if (glucoseSort.length > 0) {
            glucoseSort.sort((a, b) {
              return b.created_at - a.created_at;
            });
          }
        }
        if (state.bloodpressure!.length > 0) {
          state.bloodpressure!.forEach((element) {
            MainPressureModelwithID mainPressureModelwithID =
                MainPressureModelwithID.fromJson(element);
            MainBloodPressureModel mainBloodPressureModel =
                MainBloodPressureModel.fromJson(mainPressureModelwithID.data);
            // List<BloodPressureModel> pressureSort = [];
            mainBloodPressureModel.readings!.forEach((element) {
              BloodPressureModel bloodPressureModel =
                  BloodPressureModel.fromJson(element);
              pressureSort.add(bloodPressureModel);
            });
          });
          if (pressureSort.length > 0) {
            pressureSort.sort((a, b) {
              return b.created_at - a.created_at;
            });
          }
        }
        if (state.bodyweight!.length > 0) {
          state.bodyweight!.forEach((element) {
            MainWeightModelwithID mainWeightModelwithID =
                MainWeightModelwithID.fromJson(element);
            MainBodyWeightModel mainBodyWeightModel =
                MainBodyWeightModel.fromJson(mainWeightModelwithID.data);

            mainBodyWeightModel.readings!.forEach((element) {
              BodyWeightModel bodyWeightModel =
                  BodyWeightModel.fromJson(element);
              weightSort.add(bodyWeightModel);
            });
          });
          if (weightSort.length > 0) {
            weightSort.sort((a, b) {
              return a.created_at - b.created_at;
            });
          }
        }
        // log(glucoseSort[0].pre_meal.toString(),name: 'Glucose sort');
        return Scaffold(
          body: SafeArea(
              child: Stack(
            children: [
              Background(),
              Positioned(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50.0),
                  ),
                  color: const Color(0x28000000),
                ),
              )),
              ListView(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 100),
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RedText(
                          text: 'Hello',
                          weight: FontWeight.normal,
                        ),
                        RedText(
                          text: state.userModel!.full_name,
                          size: 18,
                        )
                      ]),
                  Container(
                      margin: EdgeInsets.only(top: 15, bottom: 10),
                      child: DarkRedText(
                        size: 13,
                        text: 'Your recent recording',
                      )),
                  state.bloodpressure!.length == 0 &&
                          state.bloodglucose!.length == 0 &&
                          state.bodyweight!.length == 0
                      ? RedText(
                          text: 'No records available',
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                                visible: glucoseSort.length > 0,
                                child: RecentCard(
                                  value: glucoseSort.length > 0
                                      ? ((glucoseSort[0].pre_meal +
                                                  glucoseSort[0].post_meal) /
                                              2)
                                          .toStringAsFixed(1)
                                      : '',
                                  unit: 'mmol/L',
                                  background: defaultColors.darkRed,
                                  poster: Image.asset('lib/Assets/sugar.png'),
                                )),
                            Visibility(
                              visible: pressureSort.length > 0,
                              child: RecentCard(
                                  value: pressureSort.length > 0
                                      ? ((pressureSort[0].systolic +
                                                  pressureSort[0].diastolic) /
                                              2)
                                          .toStringAsFixed(1)
                                      : '',
                                  unit: 'mm/hg',
                                  background: defaultColors.black,
                                  poster:
                                      Image.asset('lib/Assets/pressure.png')),
                            ),
                            Visibility(
                                visible: weightSort.length > 0,
                                child: RecentCard(
                                    value: weightSort.length > 0
                                        ? weightSort[0]
                                            .weight
                                            .toStringAsFixed(1)
                                        : '',
                                    unit: 'kg',
                                    background: defaultColors.primary,
                                    poster:
                                        Image.asset('lib/Assets/scale.png'))),
                          ],
                        ),
                  Container(
                      margin: EdgeInsets.only(top: 15, bottom: 10),
                      child: DarkRedText(
                        size: 13,
                        text: 'Tip for the Day',
                      )),
                  state.tips.length == 0
                      ? RedText(
                          text: 'No tips available',
                        )
                      : Hero(
                          tag: state.tips[0].tip_id,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            margin:
                                EdgeInsets.only(top: 5, left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: defaultColors.darkblue,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: defaultColors.shadowColorGrey,
                                      offset: Offset(0, 5),
                                      blurRadius: 10)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    WhiteText(text: state.tips[0].title),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                WhiteText(
                                    size: 10,
                                    weight: FontWeight.normal,
                                    text: state.tips[0].description.length > 150
                                        ? state.tips[0].description
                                                .substring(0, 150) +
                                            '${state.tips[0].description.length > 150 ? '...' : ''}'
                                        : state.tips[0].description),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DarkGreenText(
                                      text: date,
                                      size: 10,
                                    ),
                                    TextButton(
                                      child: Row(
                                        children: [
                                          WhiteText(
                                            text: 'Read More',
                                            size: 10,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: defaultColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(0, 5),
                                                      blurRadius: 10,
                                                      color: defaultColors
                                                          .shadowColorGrey)
                                                ]),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute<void>(builder:
                                                (BuildContext context) {
                                          return Scaffold(
                                            appBar: AppBar(
                                              backgroundColor:
                                                  defaultColors.darkblue,
                                              title: Text(state.tips[0].title),
                                              leading: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ),
                                            body: Hero(
                                                tag: state.tips[0].tip_id,
                                                child: Container(
                                                    // The blue background emphasizes that it's a new route.
                                                    color: Colors.white,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: DarkBlueText(
                                                      text: state
                                                          .tips[0].description,
                                                    ))),
                                          );
                                        }));
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          bottom: 10),
                      child: DarkRedText(
                        size: 13,
                        text: 'Check and record your readings',
                      )),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: MediaQuery.of(context).size.width * 0.09,
                    runSpacing: MediaQuery.of(context).size.height * 0.05,
                    children: [
                      {
                        'title': 'Blood Glucose',
                        'poster': 'lib/Assets/sugar.png',
                        'background': defaultColors.darkRed
                      },
                      {
                        'title': 'Blood Pressure',
                        'poster': 'lib/Assets/pressure.png',
                        'background': defaultColors.black
                      },
                      {
                        'title': 'Body Weight',
                        'poster': 'lib/Assets/scale.png',
                        'background': defaultColors.primary
                      },
                      {
                        'title': 'All Statistics',
                        'poster': 'lib/Assets/statistics.png',
                        'background': defaultColors.green
                      }
                    ].map((e) {
                      RecordCardModel recordCardModel =
                          RecordCardModel.fromJson(e);
                      return RecordCard(
                        title: recordCardModel.title,
                        poster: recordCardModel.poster,
                        onPressed: () {
                          pushNewScreen(context,
                              screen: e['title'] == 'All Statistics'
                                  ? AllStatistics()
                                  : Record(
                                      title: e['title'].toString(),
                                    ),
                              withNavBar: false);
                        },
                        background: recordCardModel.background,
                      );
                    }).toList(),
                  )
                ],
              )
            ],
          )),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
