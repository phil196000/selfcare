import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';

class Reminder extends StatefulWidget {
  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, vm) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      tz.initializeTimeZones();
                      await flutterLocalNotificationsPlugin.zonedSchedule(
                          0,
                          'scheduled title',
                          'scheduled body',
                          tz.TZDateTime.now(tz.local)
                              .add(const Duration(seconds: 5)),
                          const NotificationDetails(
                              android: AndroidNotificationDetails(
                                  'your channel id',
                                  'your channel name',
                                  'your channel description')),
                          androidAllowWhileIdle: true,
                          uiLocalNotificationDateInterpretation:
                              UILocalNotificationDateInterpretation
                                  .absoluteTime);
                      log('done');
                    },
                    child: Text('Press me'))
              ],
            ),
          ),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
