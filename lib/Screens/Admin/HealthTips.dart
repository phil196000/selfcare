import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/redux/AppState.dart';

class HealthTips extends StatefulWidget {
  @override
  _HealthTipsState createState() => _HealthTipsState();
}

class _HealthTipsState extends State<HealthTips> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, vm) {
        return Scaffold(
          body: SafeArea(
              child: Stack(
            children: [
              Positioned(
                  bottom: 60,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {},
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
