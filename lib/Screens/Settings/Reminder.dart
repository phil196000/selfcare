import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/redux/AppState.dart';

class Reminder extends StatefulWidget {
  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(builder: (context, vm) {
      return Scaffold(
        body: SafeArea(
          child: ListView(
            children: [

            ],
          ),
        ),
      );
    }, converter: (Store<AppState> store) => store.state,);
  }
}
