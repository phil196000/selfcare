import 'package:flutter/material.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData avatar;

  const SettingCard({ required this.title, required this.color, required this.avatar})
      ;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        padding: EdgeInsets.zero,
        elevation: 3,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () => null,
        child: Container(
            // margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                color: DefaultColors().white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 2, color: color),
                boxShadow: [
                  BoxShadow(
                      color: DefaultColors().lightdarkRed,
                      blurRadius: 10,
                      offset: Offset(0, 5))
                ]
                // border: Border

                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: CircleAvatar(
                        backgroundColor: color,
                        child: Icon(
                          avatar,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        // fontFamily: 'Segoe UI',
                        fontSize: 18,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                      // textAlign: TextAlign.left,
                    )
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  size: 40,
                  color: color,
                )
              ],
            )));
  }
}
