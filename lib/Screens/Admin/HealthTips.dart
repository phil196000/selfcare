import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/HealthTip.dart';
import 'package:selfcare/Screens/Admin/AddTipsModal.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';

import '../Record.dart';

class HealthTips extends StatefulWidget {
  final Function? hidenavbar;

  HealthTips({this.hidenavbar});

  @override
  _HealthTipsState createState() => _HealthTipsState();
}

class _HealthTipsState extends State<HealthTips> {
  void openUserModal() {
    widget.hidenavbar!(true);
    // log('pressed');
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AddTipsModal(
          closeModal: () {
            widget.hidenavbar!(false);
            Navigator.pop(context);
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  DefaultColors defaultColors = DefaultColors();

  Future<void> deleteTip({required TipModel e}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('DELETE TIP')],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RedText(text: 'You are about to delete this tip'),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: DarkRedText(
                    text: 'Do you want to proceed?',
                    weight: FontWeight.normal,
                    size: 14,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: RedText(
                text: 'NO',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: DarkGreenText(
                text: 'YES',
              ),
              onPressed: () {
                DocumentReference tipRef =
                    FirebaseFirestore.instance.collection('tips').doc(e.tip_id);
                tipRef.delete().then((value) {
                  log('deleted');
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  // onVisible: () => Timer(
                  //     Duration(seconds: 2),
                  //         () => Navigator.of(context).pop()),
                  backgroundColor: Colors.green,
                  content: Container(
                    // color: Colors.yellow,
                    child: WhiteText(
                      text: 'Tip deleted successfully',
                    ),
                  ),
                  duration: Duration(milliseconds: 2000),
                ));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        return Scaffold(
          body: SafeArea(
              child: Stack(
            children: [
              Positioned.fill(
                child: ListView(
                  padding: EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 120),
                  children: [
                    // DarkBlueText(text: 'Today'),
                    ...state.tips.map((e) {
                      DateTime dateTime =
                          DateTime.fromMillisecondsSinceEpoch(e.created_at);
                      String date =
                          '${dateTime.day} ${monthSelectedString(dateTime.month - 1)} ${dateTime.year} at ${dateTime.hour == 0 ? '12' : dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}:${dateTime.second < 10 ? '0${dateTime.second}' : dateTime.second} ${dateTime.hour > 11 ? 'PM' : 'AM'}';
                      return Hero(
                          tag: e.tip_id,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            margin:
                                EdgeInsets.only(top: 5, left: 15, right: 15),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    WhiteText(text: e.title),
                                    IconButton(
                                        color: Colors.red,
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () {
                                          deleteTip(e: e);
                                        })
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            MaterialPageRoute<void>(builder:
                                                (BuildContext context) {
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
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    alignment:
                                                        Alignment.topLeft,
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
              Positioned(
                  bottom: 60,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      openUserModal();
                    },
                    child: Icon(Icons.add),
                  )),
            ],
          )),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
