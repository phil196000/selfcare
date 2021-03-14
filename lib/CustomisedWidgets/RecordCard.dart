import 'package:flutter/material.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

import 'WhiteText.dart';
class RecordCard extends StatelessWidget {
  final Function onPressed;
  final Color background;
  final String title;
  final String poster;
  DefaultColors defaultColors = DefaultColors();

   RecordCard({Key? key,  required this.onPressed, required this.background,required this.title, required this.poster}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  RaisedButton(
      onPressed:()=> this.onPressed(),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.only(bottom: 13, top: 22,left: 22),
        decoration: BoxDecoration(
            color: this.background,
            boxShadow: [
              BoxShadow(
                  color: defaultColors.shadowColorRed,
                  offset: Offset(0, 5),
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,

              child: Image.asset(this.poster,width: 30,height: 30,fit: BoxFit.contain,),
            ),
            Container(
              child: WhiteText(
                size: 18,
                text: this.title,
              ),
              margin: EdgeInsets.only(top: 14),
            )
          ],
        ),
      ),
    );
  }
}
