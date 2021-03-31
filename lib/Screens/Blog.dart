import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/Actions/TipsAction.dart';
import 'package:selfcare/redux/AppState.dart';

import '../main.dart';
import 'Record.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  DefaultColors defaultColors = DefaultColors();

  @override
  void initState() {
    super.initState();
    log('tip ran');
    getIt.get<Store<AppState>>().dispatch(TipsAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                Visibility(
                  child: RedText(
                    text: 'No tips available yet',
                  ),
                  visible: state.tips.length == 0,
                ),
                ...state.tips.map((e) {
                  DateTime dateTime =
                      DateTime.fromMillisecondsSinceEpoch(e.created_at);
                  String date =
                      '${dateTime.day} ${monthSelectedString(dateTime.month - 1)} ${dateTime.year} at ${dateTime.hour == 0 ? '12' : dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${dateTime.hour > 11 ? 'PM' : 'AM'}';
                  return Hero(
                      tag: e.tip_id,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                        decoration: BoxDecoration(
                            color: defaultColors.darkblue,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: defaultColors.shadowColorGrey,
                                  offset: Offset(0, 5),
                                  blurRadius: 10)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WhiteText(text: e.title),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            WhiteText(
                                size: 10,
                                weight: FontWeight.normal,
                                text: e.description.length > 150
                                    ? e.description.substring(0, 150) +
                                        '${e.description.length > 150 ? '...' : ''}'
                                    : e.description),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DarkGreenText(
                                  text: date,
                                  size: 10,
                                ),
                                TextButton(
                                  child: Row(
                                    children: [
                                      WhiteText(
                                        text: 'Read More',
                                        size: 10,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: defaultColors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 5),
                                                  blurRadius: 10,
                                                  color: defaultColors
                                                      .shadowColorGrey)
                                            ]),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) {
                                      return Scaffold(
                                        appBar: AppBar(
                                          backgroundColor:
                                              defaultColors.darkblue,
                                          title: Text(e.title),
                                          leading: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.close),
                                          ),
                                        ),
                                        body: Hero(
                                            tag: e.tip_id,
                                            child: Container(
                                                // The blue background emphasizes that it's a new route.
                                                color: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                alignment: Alignment.topLeft,
                                                child: DarkBlueText(
                                                  text: e.description,
                                                ))),
                                      );
                                    }));
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ));
                })
              ],
            ),
          ),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
