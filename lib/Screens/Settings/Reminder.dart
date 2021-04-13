import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/PrimaryButton.dart';
import 'package:selfcare/CustomisedWidgets/TextButton.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';

class Reminder extends StatefulWidget {
  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  bool reminder = true;
  late TimeOfDay timeOfDay;

  tz.TZDateTime _nextInstanceOfTenAM(
      {TimeOfDay time = const TimeOfDay(hour: 9, minute: 0)}) {
    tz.initializeTimeZones();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    log(tz.local.toString(), name: 'tz local');
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _saveReminderTime({required TimeOfDay reminderTime}) async {
    final SharedPreferences prefs = await _prefs;
    log('i ran saveReminder');
    prefs
        .setString(
      "reminder",
      jsonEncode({'hour': reminderTime.hour, 'minute': reminderTime.minute}),
    )
        .then((value) {
      log('reminder saved and done');
      scheduleNotification(time: reminderTime);
    }).catchError((error) {
      log(error.toString());
    });
    log('after pref ran');
  }

  @override
  void initState() {
    super.initState();
    _checkPendingNotificationRequests();
    setState(() {
      timeOfDay = TimeOfDay(hour: 9, minute: 0);
    });
    _prefs.then((SharedPreferences prefs) {
      var remind = prefs.getString('reminder') ?? null;

      // log(email.toString(), name: 'email');
      // log(password.toString(), name: 'password');
      if (remind != null) {
        TimeOfDay remindTimeOfDay = TimeOfDay(
            hour: jsonDecode(remind)['hour'],
            minute: jsonDecode(remind)['minute']);
        setState(() {
          timeOfDay = remindTimeOfDay;
        });
      } else {
        log(' reminder is null');
        setState(() {
          timeOfDay = TimeOfDay(hour: 9, minute: 0);
          setState(() {
            reminder = false;
          });
        });
      }
    });
  }

  @override
  Future<List<PendingNotificationRequest>>
      _checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    log((pendingNotificationRequests[0].payload!).toString());
    return pendingNotificationRequests;
  }

  void scheduleNotification(
      {TimeOfDay time = const TimeOfDay(hour: 9, minute: 0)}) async {
    log('i ran scheduleNotification');
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Reminder',
        'Have you input your readings for the day yet?',
        _nextInstanceOfTenAM(time: time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'reminder_channel_id',
              'reminder channel',
              'This is the recurring reminder notification'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, vm) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding:
                  EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 60),
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: DefaultColors().shadowColorGrey))),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: DarkRedText(
                        text: 'Reminder Switch: ${reminder ? 'ON' : 'OFF'}'),
                    trailing: Switch(
                      value: reminder,
                      onChanged: (bool value) async {
                        setState(() {
                          reminder = value;
                        });
                        if (value) {
                          _saveReminderTime(reminderTime: timeOfDay);
                        } else {
                          final SharedPreferences prefs = await _prefs;
                          // final String counter = (prefs.getString('email') ?? 'Hello');

                          prefs.remove('reminder').then((value) {
                            _cancelNotification(0);
                          });
                        }
                      },
                    ),
                  ),
                ),
                // DarkRedText(text: 'Reminder Details'),
                // FutureBuilder(
                //   future: _checkPendingNotificationRequests(),
                //   builder: (context,
                //       AsyncSnapshot<List<PendingNotificationRequest>>
                //           snapshot) {
                //     if (snapshot.hasData) {
                //       return Column(
                //         children: [
                //           ...snapshot.data!.map((e) {
                //             return DarkGreenText(text: e.body!);
                //           })
                //         ],
                //       );
                //     }
                //     return Visibility(child: Container());
                //   },
                // ),
                Visibility(
                  visible: reminder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      DarkRedText(text: 'Reminder Time'),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DarkGreenText(
                            text:
                                '${timeOfDay.hour == 0 ? '12' : timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.hour > 11 ? 'PM' : 'AM'}',
                          ),
                          PrimaryButton(
                            text: 'Change',
                            onPressed: () async {
                              TimeOfDay? timeofday = await showTimePicker(
                                  context: context, initialTime: timeOfDay);
                              log(timeofday!.hour.toString());
                              setState(() {
                                timeOfDay = timeofday;
                              });
                              _saveReminderTime(reminderTime: timeofday);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       _checkPendingNotificationRequests();
                //       // tz.initializeTimeZones();
                //       // await flutterLocalNotificationsPlugin.zonedSchedule(
                //       //     0,
                //       //     'scheduled title',
                //       //     'scheduled body',
                //       //     tz.TZDateTime.now(tz.local)
                //       //         .add(const Duration(seconds: 5)),
                //       //     const NotificationDetails(
                //       //         android: AndroidNotificationDetails(
                //       //             'your channel id',
                //       //             'your channel name',
                //       //             'your channel description')),
                //       //     androidAllowWhileIdle: true,
                //       //     uiLocalNotificationDateInterpretation:
                //       //         UILocalNotificationDateInterpretation
                //       //             .absoluteTime);
                //       log('done');
                //     },
                //     child: Text('Press me'))
              ],
            ),
          ),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
