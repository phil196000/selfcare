import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/AllStats/Chart.dart';
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
  String dropdownValue = 'One';
  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final myDesktopData = [
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 9, 19), sales: 5),
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 9, 26), sales: 25),
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 10, 3), sales: 100),
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 10, 10), sales: 75),
    ];

    final myTabletData = [
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 9, 19), sales: 10),
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 9, 26), sales: 50),
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 10, 3), sales: 200),
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 10, 10), sales: 150),
    ];

    // Example of a series with two range annotations. A regular point shape
    // will be drawn at the current domain value, and a range shape will be
    // drawn between the previous and target domain values.
    //
    // Note that these series do not contain any measure values. They are
    // positioned automatically in rows.
    final myAnnotationData1 = [
      new TimeSeriesSales(
        timeCurrent: new DateTime(2017, 9, 24),
        timePrevious: new DateTime(2017, 9, 19),
        timeTarget: new DateTime(2017, 9, 24),
      ),
      new TimeSeriesSales(
        timeCurrent: new DateTime(2017, 9, 29),
        timePrevious: new DateTime(2017, 9, 29),
        timeTarget: new DateTime(2017, 10, 4),
      ),
    ];

    // Example of a series with one range annotation and two single point
    // annotations. Omitting the previous and target domain values causes that
    // datum to be drawn as a single point.
    final myAnnotationData2 = [
      new TimeSeriesSales(
        timeCurrent: new DateTime(2017, 9, 25),
        timePrevious: new DateTime(2017, 9, 21),
        timeTarget: new DateTime(2017, 9, 25),
      ),
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 9, 31)),
      new TimeSeriesSales(timeCurrent: new DateTime(2017, 10, 5)),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.timeCurrent,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: myDesktopData,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.timeCurrent,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: myTabletData,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Annotation Series 1',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.timeCurrent,
        domainLowerBoundFn: (TimeSeriesSales row, _) => row.timePrevious,
        domainUpperBoundFn: (TimeSeriesSales row, _) => row.timeTarget,
        // No measure values are needed for symbol annotations.
        measureFn: (_, __) => null,
        data: myAnnotationData1,
      )
      // // Configure our custom symbol annotation renderer for this series.
      //   ..setAttribute(charts.rendererIdKey, 'customSymbolAnnotation')
      // // Optional radius for the annotation shape. If not specified, this will
      // // default to the same radius as the points.
      //   ..setAttribute(charts.boundsLineRadiusPxKey, 3.5),
      // new charts.Series<TimeSeriesSales, DateTime>(
      //   id: 'Annotation Series 2',
      //   colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      //   domainFn: (TimeSeriesSales sales, _) => sales.timeCurrent,
      //   domainLowerBoundFn: (TimeSeriesSales row, _) => row.timePrevious,
      //   domainUpperBoundFn: (TimeSeriesSales row, _) => row.timeTarget,
      //   // No measure values are needed for symbol annotations.
      //   measureFn: (_, __) => null,
      //   data: myAnnotationData2,
      // )
      // // Configure our custom symbol annotation renderer for this series.
      //   ..setAttribute(charts.rendererIdKey, 'customSymbolAnnotation')
      // // Optional radius for the annotation shape. If not specified, this will
      // // default to the same radius as the points.
      //   ..setAttribute(charts.boundsLineRadiusPxKey, 3.5),
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
                                    side: BorderSide(
                                        color: defaultColors.darkRed)),
                                labelStyle:
                                    TextStyle(color: defaultColors.darkRed),
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
                                    side: BorderSide(
                                        color: defaultColors.darkRed)),
                                labelStyle:
                                    TextStyle(color: defaultColors.darkRed),
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
                                    side: BorderSide(
                                        color: defaultColors.darkRed)),
                                labelStyle:
                                    TextStyle(color: defaultColors.darkRed),
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
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: TimeSeriesSymbolAnnotationChart
                                .withSampleData(),
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
  final int? value;

  TimeSeriesModel(
      {this.timeCurrent, this.timePrevious, this.timeTarget, this.value});
}