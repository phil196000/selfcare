import 'package:flutter/material.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

import 'WhiteText.dart';

class RecentCard extends StatelessWidget {
  DefaultColors defaultColors = DefaultColors();
  final String value;
  final String unit;
  final Color background;
  final Image? poster;
  final String title1;
  final String title2;
  final String value2;
  final bool showGlucose;

  RecentCard(
      {Key? key,
      this.showGlucose = false,
      this.title2 = '',
      this.value2 = '',
      this.title1 = '',
      required this.value,
      required this.unit,
      this.background = Colors.red,
      this.poster})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 5),
      decoration: BoxDecoration(
          color: this.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: defaultColors.white)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: showGlucose
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WhiteText(
                            text: this.title1,
                            size: 10,
                          ),
                          WhiteText(
                            text: this.value,
                            size: 30,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WhiteText(
                            text: this.title2,
                            size: 10,
                          ),
                          WhiteText(
                            text: this.value2,
                            size: 30,
                          )
                        ],
                      )
                    ],
                  )
                : WhiteText(
                    text: this.value,
                    size: 30,
                  ),
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(bottom: 8),
          ),
          Row(
            children: [
              Opacity(
                opacity: 0.5,
                child: this.poster,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                child: WhiteText(
                  text: this.unit,
                  size: 11,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
