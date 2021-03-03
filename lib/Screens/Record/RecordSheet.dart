import 'package:flutter/material.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class RecordSheet extends StatefulWidget {
  @override
  _RecordSheetState createState() => _RecordSheetState();
}

class _RecordSheetState extends State<RecordSheet> {
  DefaultColors defaultColors = DefaultColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.15),
      child: ListView(
        padding: EdgeInsets.only(top: 10),
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: defaultColors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: defaultColors.shadowColorGrey,
                            offset: Offset(0, 5),
                            blurRadius: 10)
                      ],
                      border:
                          Border.all(width: 1, color: defaultColors.primary)),
                  child: RedText(
                    text: 'Change',
                  ),
                ),
              )
            ],
          ),
          Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: defaultColors.darkRed,
                      borderRadius: BorderRadius.circular(5)),
                  child: Image.asset('lib/Assets/emptybowl.png'),
                ),
                DarkRedText(text: 'Pre Meal')
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 38,
                    height: 38,
                    child: RaisedButton(
                      padding: EdgeInsets.zero,
                      color: defaultColors.white,
                      elevation: 6,
                      // minWidth: 38,
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child:Icon(Icons.remove)
                    )),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: TextField(
                    // controller: this.controller,
                    // obscureText: this.obscureText,
                    style: TextStyle(

                        color: defaultColors.darkRed, fontWeight: FontWeight.bold),
                    cursorColor: defaultColors.darkRed,
                    decoration: InputDecoration(
                        fillColor: defaultColors.white,
                        filled: true,
                        // hintText: "Enter Phone number",
                        hintStyle: TextStyle(
                            color: defaultColors.darkRed,
                            fontWeight: FontWeight.normal),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: defaultColors.primary,
                                width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide:
                            BorderSide(color: defaultColors.primary, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: defaultColors.primary,
                                width: 2)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide:
                            BorderSide(color: defaultColors.primary, width: 2))),
                  ),
                ),
                Container(
                    width: 38,
                    height: 38,
                    child: RaisedButton(
                        padding: EdgeInsets.zero,
                        color: defaultColors.white,
                        elevation: 6,
                        // minWidth: 38,
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child:Icon(Icons.add)
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
