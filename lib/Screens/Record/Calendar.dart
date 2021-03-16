import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:redux/redux.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/redux/AppState.dart';

class Calendar extends StatelessWidget {
  final Function? onDayPressed;
  final DateTime? selectedDate;
  final String screen;

  Calendar({this.onDayPressed, this.selectedDate, required this.screen});

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: CalendarCarousel<Event>(
            onDayPressed: (DateTime date, List<Event> events) =>
                this.onDayPressed!(date, events),
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),

            thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
            customDayBuilder: (
              /// you can provide your own build function to make custom day containers
              bool isSelectable,
              int index,
              bool isSelectedDay,
              bool isToday,
              bool isPrevMonthDay,
              TextStyle textStyle,
              bool isNextMonthDay,
              bool isThisMonthDay,
              DateTime day,
            ) {
              /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
              /// This way you can build custom containers for specific days only, leaving rest as default.
              if (state.bloodglucose!.length > 0) {
                return Center(
                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.day.toString(),
                        style: TextStyle(
                            color: isPrevMonthDay || isNextMonthDay
                                ? Colors.grey
                                : isToday || isSelectedDay
                                    ? Colors.white
                                    : Colors.black),
                      ),
                      Visibility(
                          visible: screen == 'Blood Glucose',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: state.bloodglucose!.map((e) {
                              MainGlucoseModelwithID
                              initMainGlucoseModelwithID =
                              MainGlucoseModelwithID.fromJson(e);

                              MainBloodGlucoseModel mainBloodGlucoseModel =
                              MainBloodGlucoseModel.fromJson(
                                  initMainGlucoseModelwithID.data);
                              String dayDateString =
                                  '${day.day}-${day.month}-${day.year}';
                              if (mainBloodGlucoseModel.date_for ==
                                  dayDateString &&
                                  mainBloodGlucoseModel.readings!.length > 0 &&
                                  !mainBloodGlucoseModel.is_deleted) {
                                return Container(
                                  width: 3,
                                  height: 3,
                                  color: Colors.black,
                                );
                              }
                              return Container();
                            }).toList(),
                          )),
                      Visibility(
                          visible: screen == 'Blood Pressure',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: state.bloodpressure!.map((e) {
                              MainPressureModelwithID
                                  initMainPressureModelwithID =
                                  MainPressureModelwithID.fromJson(e);

                              MainBloodPressureModel mainBloodPressureModel =
                                  MainBloodPressureModel.fromJson(
                                      initMainPressureModelwithID.data);
                              String dayDateString =
                                  '${day.day}-${day.month}-${day.year}';
                              if (mainBloodPressureModel.date_for ==
                                      dayDateString &&
                                  mainBloodPressureModel.readings!.length > 0 &&
                                  !mainBloodPressureModel.is_deleted) {
                                return Container(
                                  width: 3,
                                  height: 3,
                                  color: Colors.black,
                                );
                              }
                              return Container();
                            }).toList(),
                          ))
                    ],
                  ),
                ));
              }
              // Example: every 15th of month, we have a flight, we can place an icon in the container like that:

              return null;
            },
            weekFormat: false,
            // markedDatesMap: _markedDateMap,
            height: 420.0,
            selectedDateTime: state.selectedDate,
            daysHaveCircularBorder: true,

            /// null for not rendering any border, true for circular border, false for rectangular border
          ),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
