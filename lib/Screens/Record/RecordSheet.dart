import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/PrimaryButton.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/Screens/Record/AddRecordForm.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class RecordSheet extends StatefulWidget {
  @override
  _RecordSheetState createState() => _RecordSheetState();
}

class _RecordSheetState extends State<RecordSheet> {
  DefaultColors defaultColors = DefaultColors();
  TextEditingController preMeal = TextEditingController();
  TextEditingController postMeal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) => Container(
            height: isKeyboardVisible
                ? MediaQuery.of(context).size.height * 0.9
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
                        top: 10,
                        bottom: isKeyboardVisible
                            ? MediaQuery.of(context).size.height * 0.6
                            : 20),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: RedText(text: 'RECORD BLOOD GLUCOSE'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DarkRedText(
                                  text: '15 February 2021',
                                  size: 13,
                                ),
                                DarkRedText(
                                  text: '10:43 AM',
                                  size: 13,
                                )
                              ],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.zero,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: defaultColors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: defaultColors.shadowColorGrey,
                                        offset: Offset(0, 5),
                                        blurRadius: 10)
                                  ],
                                  border: Border.all(
                                      width: 1, color: defaultColors.primary)),
                              child: RedText(
                                text: 'Change',
                              ),
                            ),
                          )
                        ],
                      ),
                      AddRecordForm(
                        title: 'Pre Meal',
                        minusOnPressed: () {},
                        addOnPressed: () => null,
                        textEditingController: preMeal,
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      AddRecordForm(
                        title: 'Post Meal',
                        minusOnPressed: () {},
                        addOnPressed: () => null,
                        textEditingController: postMeal,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onPressed: () => null,
                            padding: EdgeInsets.zero,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 11),
                              decoration: BoxDecoration(
                                  color: defaultColors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: defaultColors.primary)),
                              child: RedText(text: 'Cancel'),
                            ),
                          ),
                          PrimaryButton(
                            verticalPadding: 12,
                            text: 'Save',
                            onPressed: () => null,
                            horizontalPadding: 25,
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
