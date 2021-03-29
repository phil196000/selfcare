import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class AddRecordForm extends StatelessWidget {
  final DefaultColors defaultColors = DefaultColors();
  final String title;
  final TextEditingController? textEditingController;
  final Function? minusOnPressed;
  final Function? addOnPressed;
  final bool avatar;

  AddRecordForm(
      {required Key key,
      required this.title,
      this.textEditingController,
      this.minusOnPressed,
      this.addOnPressed,
      this.avatar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Row(
          children: [
            Visibility(
              visible: this.avatar,
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    color: defaultColors.darkRed,
                    borderRadius: BorderRadius.circular(5)),
                child: title == 'Pre Meal'
                    ? Image.asset('lib/Assets/emptybowl.png')
                    : Image.asset('lib/Assets/fullbowl.png'),
              ),
            ),
            DarkRedText(text: this.title)
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
                    onPressed: () => minusOnPressed!(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Icons.remove))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.19,
                  child: TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                    ],
                    // maxLength: 3,
                    controller: this.textEditingController,
                    // controller: this.controller,
                    // obscureText: this.obscureText,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: defaultColors.darkRed,
                        fontWeight: FontWeight.bold),
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
                            borderSide: BorderSide(
                                color: defaultColors.primary, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: defaultColors.primary,
                                width: 2)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                color: defaultColors.primary, width: 2))),
                  ),
                ),
                DarkRedText(
                    size: 16,
                    text: title == 'Pre Meal' || title == 'Post Meal'
                        ? 'mmol/L'
                        : title == 'Systolic' || title == 'Diastolic'
                            ? 'mm/hg'
                            : 'kg')
              ],
            ),
            Container(
                width: 38,
                height: 38,
                child: RaisedButton(
                    padding: EdgeInsets.zero,
                    color: defaultColors.white,
                    elevation: 6,
                    // minWidth: 38,
                    onPressed: () => addOnPressed!(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Icons.add))),
          ],
        ),
      )
    ]);
  }
}
