import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RecentCard.dart';
import 'package:selfcare/CustomisedWidgets/RecordCard.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/RecordCardModel.dart';
import 'package:selfcare/Screens/AllStatistics.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';

import 'Record.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List recentRecording = [
  {'value': 128, 'unit': 'mg/dl'}
];

class _HomeState extends State<Home> {
  DefaultColors defaultColors = DefaultColors();

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) => Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Background(),
            Positioned(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50.0),
                ),
                color: const Color(0x28000000),
              ),
            )),
            ListView(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 100),
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  RedText(
                    text: 'Hello',
                    weight: FontWeight.normal,
                  ),
                  RedText(
                    text: state.userModel!.full_name,
                    size: 18,
                  )
                ]),
                Container(
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    child: DarkRedText(
                      size: 13,
                      text: 'Your recent recording',
                    )),
                state.bodyweight!.length == 0 &&
                        state.bodyweight!.length == 0 &&
                        state.bodyweight!.length == 0
                    ? RedText(
                        text: 'No records availble',
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RecentCard(
                            value: '128',
                            unit: 'mg/dl',
                            background: defaultColors.darkRed,
                            poster: Image.asset('lib/Assets/sugar.png'),
                          ),
                          RecentCard(
                              value: '59',
                              unit: 'mm/hg',
                              background: defaultColors.black,
                              poster: Image.asset('lib/Assets/pressure.png')),
                          RecentCard(
                              value: '75',
                              unit: 'kg',
                              background: defaultColors.primary,
                              poster: Image.asset('lib/Assets/scale.png')),
                        ],
                      ),
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.12,
                        bottom: 10),
                    child: DarkRedText(
                      size: 13,
                      text: 'Check and record your readings',
                    )),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: MediaQuery.of(context).size.width * 0.09,
                  runSpacing: MediaQuery.of(context).size.height * 0.05,
                  children: [
                    {
                      'title': 'Blood Glucose',
                      'poster': 'lib/Assets/sugar.png',
                      'background': defaultColors.darkRed
                    },
                    {
                      'title': 'Blood Pressure',
                      'poster': 'lib/Assets/pressure.png',
                      'background': defaultColors.black
                    },
                    {
                      'title': 'Body Weight',
                      'poster': 'lib/Assets/scale.png',
                      'background': defaultColors.primary
                    },
                    {
                      'title': 'All Statistics',
                      'poster': 'lib/Assets/statistics.png',
                      'background': defaultColors.green
                    }
                  ].map((e) {
                    RecordCardModel recordCardModel =
                        RecordCardModel.fromJson(e);
                    return RecordCard(
                      title: recordCardModel.title,
                      poster: recordCardModel.poster,
                      onPressed: () {
                        pushNewScreen(context,
                            screen: e['title'] == 'All Statistics'
                                ? AllStatistics()
                                : Record(
                                    title: e['title'].toString(),
                                  ),
                            withNavBar: false);
                      },
                      background: recordCardModel.background,
                    );
                  }).toList(),
                )
              ],
            )
          ],
        )),
      ),
      converter: (Store<AppState> store) => store.state,
    );
  }
}
