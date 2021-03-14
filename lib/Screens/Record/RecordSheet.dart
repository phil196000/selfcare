import 'dart:developer';

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
import 'package:selfcare/redux/AppState.dart';

class RecordSheet extends StatelessWidget {
  final TextEditingController preMeal;

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
  });

  final DefaultColors defaultColors = DefaultColors();

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
                                          onPressed: () => timePressed!(),
                                          child: DarkRedText(
                                            text:
                                                '${selectedDate.hour > 12 ? selectedDate.hour - 12 : selectedDate.hour == 0 ? 12 : selectedDate.hour}:${selectedDate.minute < 10 ? '0${selectedDate.minute}' : selectedDate.minute} ${selectedDate.hour >= 12 ? 'PM' : 'AM'}',
                                            size: 13,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => datePressed!(),
                                          child: DarkRedText(
                                            text:
                                                '${selectedDate.day} ${monthSelectedString(selectedDate.month - 1)} ${selectedDate.year}',
                                            size: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // RaisedButton(
                                  //   onPressed: () => widget.onChangeDate!(),
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(5)),
                                  //   padding: EdgeInsets.zero,
                                  //   child: Container(
                                  //     padding: EdgeInsets.symmetric(
                                  //         vertical: 10, horizontal: 15),
                                  //     decoration: BoxDecoration(
                                  //         color: defaultColors.white,
                                  //         borderRadius: BorderRadius.circular(5),
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //               color:
                                  //                   defaultColors.shadowColorGrey,
                                  //               offset: Offset(0, 5),
                                  //               blurRadius: 10)
                                  //         ],
                                  //         border: Border.all(
                                  //             width: 1,
                                  //             color: defaultColors.primary)),
                                  //     child: RedText(
                                  //       text: 'Change',
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                              AddRecordForm(
                                key: Key('PreMealAddRecord1'),
                                title: 'Pre Meal',
                                minusOnPressed: () => onPreMealMinusPressed!(),
                                addOnPressed: () => onPreMealAddPressed!(),
                                textEditingController: preMeal,
                              ),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              AddRecordForm(
                                title: 'Post Meal',
                                minusOnPressed: () => onPostMealMinusPressed!(),
                                addOnPressed: () => onPostMealAddPressed!(),
                                textEditingController: postMeal,
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
                                    onPressed: () => onCancelPressed!(),
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
                                    onPressed: () => onSavePressed!(),
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
