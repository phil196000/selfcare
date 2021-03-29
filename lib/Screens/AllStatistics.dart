import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/AllStats/Chart.dart';
import 'package:selfcare/Screens/Record.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'Record/BarChart.dart';

class AllStatistics extends StatefulWidget {
  @override
  _AllStatisticsState createState() => _AllStatisticsState();
}

class _AllStatisticsState extends State<AllStatistics> {
  DefaultColors defaultColors = DefaultColors();
  String dropdownValue = 'All Records';
  bool choiceGlucose = true;
  bool choicePressure = true;
  bool choiceWeight = true;
  bool showFilterChips = true;
  bool statChoice = false;
  String singleChoice = 'Glucose';
  List<Widget> selectedPoint = [];

//Chart Selection
  DateTime? _time;
  late Map<String, num> _measures;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime? time;
    final measures = <String, num>{};
    List<Widget> pointsSelected = [];
    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.timeCurrent;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.value;
        log(datumPair.datum.value.toString(), name: 'value');
      });
    }
    measures.forEach((String series, num value) {
      pointsSelected.add(WhiteText(text: '$series: $value'));
    });
    // Request a build.
    setState(() {
      _time = time!;
      _measures = measures;
      selectedPoint = pointsSelected;
    });
  }

  List<charts.Series<TimeSeriesModel, DateTime>> _allStats(
      {List glucose = const [],
      List pressure = const [],
      List weight = const []}) {
    //Multiples
    List<TimeSeriesModel> glucoseForStat = [];
    List<TimeSeriesModel> pressureForStat = [];
    List<TimeSeriesModel> weightForStat = [];

    //Singles
    List<TimeSeriesModel> glucoseForStatSinglePreMeal = [];
    List<TimeSeriesModel> glucoseForStatSinglePostMeal = [];
    List<TimeSeriesModel> glucoseForStatSingle = [];
    List<TimeSeriesModel> pressureForStatSingle = [];
    List<TimeSeriesModel> pressureForStatSingleSystolic = [];
    List<TimeSeriesModel> pressureForStatSingleDiastolic = [];

    List<TimeSeriesModel> weightForStatSingle = [];
    log(weight.length.toString());
    weight.forEach((element) {
      MainWeightModelwithID mainWeightModelwithID =
          MainWeightModelwithID.fromJson(element);
      MainBodyWeightModel mainBodyWeightModel =
          MainBodyWeightModel.fromJson(mainWeightModelwithID.data);
      mainBodyWeightModel.readings!.forEach((element) {
        BodyWeightModel bodyWeightModel = BodyWeightModel.fromJson(element);
        if (dropdownValue == '30 days') {
          DateTime end = DateTime.now();
          DateTime start = DateTime.fromMillisecondsSinceEpoch(
              end.millisecondsSinceEpoch - (30 * 24 * 60 * 60 * 1000));
          DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(
              mainBodyWeightModel.date_for_timestamp_millis!);
          if (itemDate.millisecondsSinceEpoch <= end.millisecondsSinceEpoch &&
              itemDate.millisecondsSinceEpoch >= start.millisecondsSinceEpoch) {
            weightForStat.add(new TimeSeriesModel(
                timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                    bodyWeightModel.created_at),
                value: bodyWeightModel.weight));
          }
        } else if (dropdownValue == '7 days') {
          DateTime end = DateTime.now();
          DateTime start = DateTime.fromMillisecondsSinceEpoch(
              end.millisecondsSinceEpoch - (30 * 24 * 60 * 60 * 1000));
          DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(
              mainBodyWeightModel.date_for_timestamp_millis!);
          if (itemDate.millisecondsSinceEpoch <= end.millisecondsSinceEpoch &&
              itemDate.millisecondsSinceEpoch >= start.millisecondsSinceEpoch) {
            weightForStat.add(new TimeSeriesModel(
                timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                    bodyWeightModel.created_at),
                value: bodyWeightModel.weight));
          }
        } else {
          weightForStat.add(new TimeSeriesModel(
              timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                  bodyWeightModel.created_at),
              value: bodyWeightModel.weight));
        }
      });
    });

    glucose.forEach((element) {
      MainGlucoseModelwithID mainGlucoseModelwithID =
          MainGlucoseModelwithID.fromJson(element);
      MainBloodGlucoseModel mainBloodGlucoseModel =
          MainBloodGlucoseModel.fromJson(mainGlucoseModelwithID.data);
      mainBloodGlucoseModel.readings!.forEach((element) {
        BloodGlucoseModel bloodGlucoseModel =
            BloodGlucoseModel.fromJson(element);

        if (dropdownValue == '30 days') {
          DateTime end = DateTime.now();
          DateTime start = DateTime.fromMillisecondsSinceEpoch(
              end.millisecondsSinceEpoch - (30 * 24 * 60 * 60 * 1000));
          DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(
              mainBloodGlucoseModel.date_for_timestamp_millis!);
          if (itemDate.millisecondsSinceEpoch <= end.millisecondsSinceEpoch &&
              itemDate.millisecondsSinceEpoch >= start.millisecondsSinceEpoch) {
            if (!statChoice) {
              if (choiceGlucose) {
                glucoseForStat.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodGlucoseModel.created_at),
                    value: ((bloodGlucoseModel.post_meal +
                                bloodGlucoseModel.post_meal) /
                            2)
                        ));
              }
            } else {
              if (singleChoice == 'Glucose') {
                glucoseForStatSinglePreMeal.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodGlucoseModel.created_at),
                    value: bloodGlucoseModel.pre_meal));
                glucoseForStatSinglePostMeal.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodGlucoseModel.created_at),
                    value: bloodGlucoseModel.post_meal));
              }
            }
          }
        } else if (dropdownValue == '7 days') {
          DateTime end = DateTime.now();
          DateTime start = DateTime.fromMillisecondsSinceEpoch(
              end.millisecondsSinceEpoch - (7 * 24 * 60 * 60 * 1000));
          DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(
              mainBloodGlucoseModel.date_for_timestamp_millis!);
          if (itemDate.millisecondsSinceEpoch <= end.millisecondsSinceEpoch &&
              itemDate.millisecondsSinceEpoch >= start.millisecondsSinceEpoch) {
            if (!statChoice) {
              if (choiceGlucose) {
                glucoseForStat.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodGlucoseModel.created_at),
                    value: ((bloodGlucoseModel.post_meal +
                                bloodGlucoseModel.post_meal) /
                            2)
                        ));
              }
            } else {
              if (singleChoice == 'Glucose') {
                glucoseForStatSinglePreMeal.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodGlucoseModel.created_at),
                    value: bloodGlucoseModel.pre_meal));
                glucoseForStatSinglePostMeal.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodGlucoseModel.created_at),
                    value: bloodGlucoseModel.post_meal));
              }
            }
          }
        } else {
          if (!statChoice) {
            if (choiceGlucose) {
              glucoseForStat.add(new TimeSeriesModel(
                  timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                      bloodGlucoseModel.created_at),
                  value: ((bloodGlucoseModel.post_meal +
                              bloodGlucoseModel.post_meal) /
                          2)
                      ));
            }
          } else {
            if (singleChoice == 'Glucose') {
              glucoseForStatSinglePreMeal.add(new TimeSeriesModel(
                  timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                      bloodGlucoseModel.created_at),
                  value: bloodGlucoseModel.pre_meal));
              glucoseForStatSinglePostMeal.add(new TimeSeriesModel(
                  timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                      bloodGlucoseModel.created_at),
                  value: bloodGlucoseModel.post_meal));
            }
          }
        }
      });
    });

    pressure.forEach((element) {
      MainPressureModelwithID mainPressureModelwithID =
          MainPressureModelwithID.fromJson(element);
      MainBloodPressureModel mainBloodPressureModel =
          MainBloodPressureModel.fromJson(mainPressureModelwithID.data);
      mainBloodPressureModel.readings!.forEach((element) {
        BloodPressureModel bloodPressureModel =
            BloodPressureModel.fromJson(element);

        if (dropdownValue == '30 days') {
          DateTime end = DateTime.now();
          DateTime start = DateTime.fromMillisecondsSinceEpoch(
              end.millisecondsSinceEpoch - (30 * 24 * 60 * 60 * 1000));
          DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(
              mainBloodPressureModel.date_for_timestamp_millis!);
          // log(itemDate.toIso8601String());
          if (itemDate.millisecondsSinceEpoch <= end.millisecondsSinceEpoch &&
              itemDate.millisecondsSinceEpoch >= start.millisecondsSinceEpoch) {
            if (!statChoice) {
              if (choicePressure) {
                pressureForStat.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodPressureModel.created_at),
                    value: ((bloodPressureModel.systolic +
                                bloodPressureModel.diastolic) /
                            2)
                        ));
              }
            } else {
              if (singleChoice == 'Pressure') {
                pressureForStatSingleSystolic.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodPressureModel.created_at),
                    value: bloodPressureModel.systolic));
                pressureForStatSingleDiastolic.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodPressureModel.created_at),
                    value: bloodPressureModel.diastolic));
              }
            }
          }
        } else if (dropdownValue == '7 days') {
          DateTime end = DateTime.now();
          DateTime start = DateTime.fromMillisecondsSinceEpoch(
              end.millisecondsSinceEpoch - (7 * 24 * 60 * 60 * 1000));
          DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(
              mainBloodPressureModel.date_for_timestamp_millis!);
          log(itemDate.toIso8601String());
          if (itemDate.millisecondsSinceEpoch <= end.millisecondsSinceEpoch &&
              itemDate.millisecondsSinceEpoch >= start.millisecondsSinceEpoch) {
            if (!statChoice) {
              if (choicePressure) {
                pressureForStat.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodPressureModel.created_at),
                    value: ((bloodPressureModel.systolic +
                                bloodPressureModel.diastolic) /
                            2)
                        ));
              }
            } else {
              if (singleChoice == 'Pressure') {
                pressureForStatSingleSystolic.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodPressureModel.created_at),
                    value: bloodPressureModel.systolic));
                pressureForStatSingleDiastolic.add(new TimeSeriesModel(
                    timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                        bloodPressureModel.created_at),
                    value: bloodPressureModel.diastolic));
              }
            }
          }
        } else {
          if (!statChoice) {
            if (choicePressure) {
              pressureForStat.add(new TimeSeriesModel(
                  timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                      bloodPressureModel.created_at),
                  value: ((bloodPressureModel.systolic +
                              bloodPressureModel.diastolic) /
                          2)
                      ));
            }
          } else {
            if (singleChoice == 'Pressure') {
              pressureForStatSingleSystolic.add(new TimeSeriesModel(
                  timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                      bloodPressureModel.created_at),
                  value: bloodPressureModel.systolic));
              pressureForStatSingleDiastolic.add(new TimeSeriesModel(
                  timeCurrent: DateTime.fromMillisecondsSinceEpoch(
                      bloodPressureModel.created_at),
                  value: bloodPressureModel.diastolic));
            }
          }
        }
      });
    });

    return statChoice
        ? singleChoice == 'Pressure'
            ? [
                new charts.Series<TimeSeriesModel, DateTime>(
                  id: 'Pressure Single Systolic',
                  displayName: 'Systolic',
                  colorFn: (_, __) => charts.Color.fromHex(code: '#000000'),
                  domainFn: (TimeSeriesModel sales, _) => sales.timeCurrent,
                  measureFn: (TimeSeriesModel sales, _) => sales.value,
                  data: pressureForStatSingleSystolic,
                ),
                new charts.Series<TimeSeriesModel, DateTime>(
                  id: 'Pressure Single Diastolic',
                  displayName: 'Diastolic',
                  colorFn: (_, __) => charts.Color.fromHex(code: '#139932'),
                  domainFn: (TimeSeriesModel sales, _) => sales.timeCurrent,
                  measureFn: (TimeSeriesModel sales, _) => sales.value,
                  data: pressureForStatSingleDiastolic,
                )
              ]
            : singleChoice == 'Glucose'
                ? [
                    new charts.Series<TimeSeriesModel, DateTime>(
                      id: 'Glucose Single PreMeal',
                      displayName: 'Pre Meal',
                      colorFn: (_, __) => charts.Color.fromHex(code: '#530505'),
                      domainFn: (TimeSeriesModel sales, _) => sales.timeCurrent,
                      measureFn: (TimeSeriesModel sales, _) => sales.value,
                      data: glucoseForStatSinglePreMeal,
                    ),
                    new charts.Series<TimeSeriesModel, DateTime>(
                      id: 'Glucose Single PostMeal',
                      displayName: 'Post Meal',
                      colorFn: (_, __) => charts.Color.fromHex(code: '#1B0973'),
                      domainFn: (TimeSeriesModel sales, _) => sales.timeCurrent,
                      measureFn: (TimeSeriesModel sales, _) => sales.value,
                      data: glucoseForStatSinglePostMeal,
                    )
                  ]
                : [
                    new charts.Series<TimeSeriesModel, DateTime>(
                      id: 'Body Weight Single',
                      displayName: 'Weight',
                      colorFn: (_, __) => charts.Color.fromHex(code: '#FF0000'),
                      domainFn: (TimeSeriesModel sales, _) => sales.timeCurrent,
                      measureFn: (TimeSeriesModel sales, _) => sales.value,
                      data: weightForStat,
                    )
                  ]
        : [
            new charts.Series<TimeSeriesModel, DateTime>(
              id: 'Glucose',
              displayName: 'Glucose',
              colorFn: (_, __) => charts.Color.fromHex(code: '#530505'),
              domainFn: (TimeSeriesModel sales, _) => sales.timeCurrent,
              measureFn: (TimeSeriesModel sales, _) => sales.value,
              data: glucoseForStat,
            ),
            new charts.Series<TimeSeriesModel, DateTime>(
              id: 'Pressure',
              displayName: 'Pressure',
              colorFn: (_, __) => charts.Color.fromHex(code: '#000000'),
              domainFn: (TimeSeriesModel sales, _) => sales.timeCurrent,
              measureFn: (TimeSeriesModel sales, _) => sales.value,
              data: pressureForStat,
            ),
            new charts.Series<TimeSeriesModel, DateTime>(
              id: 'Body Weight Single',
              displayName: 'Weight',
              colorFn: (_, __) => charts.Color.fromHex(code: '#FF0000'),
              domainFn: (TimeSeriesModel sales, _) => sales.timeCurrent,
              measureFn: (TimeSeriesModel sales, _) => sales.value,
              data: weightForStat,
            )
          ];
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              // overflow: Overflow.visible,
              children: [
                Visibility(
                  visible: _time != null,
                  child: Positioned(
                      bottom: 50,
                      right: 5,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: defaultColors.darkRed,
                            boxShadow: [
                              BoxShadow(
                                color: defaultColors.shadowColorRed,
                                offset: Offset(0, 5),
                                blurRadius: 10
                              )
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                WhiteText(
                                  text: 'Time: ',
                                  size: 14,
                                ),
                                WhiteText(
                                    size: 14,
                                    text: _time != null
                                        ? '${_time!.day} ${monthSelectedString(_time!.month - 1)} ${_time!.year}'
                                        : '')
                              ],
                            ),
                            Row(
                              children: [
                                WhiteText(
                                  text: 'Time: ',
                                  size: 14,
                                ),
                                WhiteText(
                                    size: 14,
                                    text: _time != null
                                        ? '${_time!.hour == 0 ? '12' : _time!.hour > 12 ? _time!.hour - 12 : _time!.hour}:${_time!.minute < 10 ? '0${_time!.minute}' : _time!.minute}:${_time!.second < 10 ? '0${_time!.second}' : _time!.second} ${_time!.hour > 11 ? 'PM' : 'AM'}'
                                        : '')
                              ],
                            ),
                            Column(
                              children: selectedPoint,
                              crossAxisAlignment: CrossAxisAlignment.start,
                            )
                          ],
                        ),
                      )),
                ),
                Background(),
                Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: defaultColors.white,
                            boxShadow: [
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
                        padding: EdgeInsets.only(
                            top: 0, left: 10, right: 10, bottom: 50),
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  showFilterChips = !showFilterChips;
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7),
                                    child: DarkGreenText(
                                      text: 'Press to show filter options',
                                      size: 13,
                                    ),
                                  ),
                                  Container(
                                    child: Icon(showFilterChips
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down),
                                  )
                                ],
                              )),
                          Visibility(
                            visible: showFilterChips,
                            child: Wrap(
                              spacing: 5,
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
                                  selected: statChoice,
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      statChoice = true;
                                    });
                                  },
                                  label: Text('Single'),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                ChoiceChip(
                                  backgroundColor: Colors.transparent,
                                  selectedColor: defaultColors.lightdarkRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: defaultColors.darkRed)),
                                  labelStyle:
                                      TextStyle(color: defaultColors.darkRed),
                                  selected: !statChoice,
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      statChoice = false;
                                    });
                                  },
                                  label: Text('Multiple'),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: showFilterChips,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DarkGreenText(
                                    text: 'Choose one or more to filter',
                                    size: 13,
                                  ),
                                ],
                              )),
                          Visibility(
                            visible: showFilterChips && statChoice,
                            child: Wrap(
                              spacing: 5,
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
                                  selected: singleChoice == 'Glucose',
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      singleChoice = 'Glucose';
                                    });
                                  },
                                  label: Text('Glucose'),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                ChoiceChip(
                                  backgroundColor: Colors.transparent,
                                  selectedColor: defaultColors.lightdarkRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: defaultColors.darkRed)),
                                  labelStyle:
                                      TextStyle(color: defaultColors.darkRed),
                                  selected: singleChoice == 'Pressure',
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      singleChoice = 'Pressure';
                                    });
                                  },
                                  label: Text('Pressure'),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                ChoiceChip(
                                  backgroundColor: Colors.transparent,
                                  selectedColor: defaultColors.lightdarkRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: defaultColors.darkRed)),
                                  labelStyle:
                                      TextStyle(color: defaultColors.darkRed),
                                  selected: singleChoice == 'Weight',
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      singleChoice = 'Weight';
                                    });
                                  },
                                  label: Text('Weight'),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: showFilterChips && !statChoice,
                            child: Wrap(
                              spacing: 5,
                              children: [
                                FilterChip(
                                  backgroundColor: Colors.transparent,
                                  selectedColor: defaultColors.lightdarkRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: defaultColors.darkRed)),
                                  labelStyle:
                                      TextStyle(color: defaultColors.darkRed),
                                  selected: choiceGlucose,
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      choiceGlucose = selected;
                                    });
                                  },
                                  label: Text('Glucose'),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                FilterChip(
                                  backgroundColor: Colors.transparent,
                                  selectedColor: defaultColors.lightdarkRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: defaultColors.darkRed)),
                                  labelStyle:
                                      TextStyle(color: defaultColors.darkRed),
                                  selected: choicePressure,
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      choicePressure = selected;
                                    });
                                  },
                                  label: Text('Pressure'),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                FilterChip(
                                  backgroundColor: Colors.transparent,
                                  selectedColor: defaultColors.lightdarkRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: defaultColors.darkRed)),
                                  labelStyle:
                                      TextStyle(color: defaultColors.darkRed),
                                  selected: choiceWeight,
                                  onSelected: (bool selected) {
                                    this.setState(() {
                                      choiceWeight = selected;
                                    });
                                  },
                                  label: Text('Weight'),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                )
                              ],
                            ),
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                '7 days',
                                '30 days',
                                'All Records',
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
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: TimeSeriesSymbolAnnotationChart(
                              _allStats(
                                  weight: state.bodyweight!,
                                  glucose: state.bloodglucose!,
                                  pressure: state.bloodpressure!),
                              selectionModels: [
                                new charts.SelectionModelConfig(
                                    type: charts.SelectionModelType.info,
                                    changedListener: _onSelectionChanged)
                              ],
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
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}

class TimeSeriesModel {
  final DateTime? timeCurrent;
  final DateTime? timePrevious;
  final DateTime? timeTarget;
  final double? value;

  TimeSeriesModel(
      {this.timeCurrent, this.timePrevious, this.timeTarget, this.value});
}
