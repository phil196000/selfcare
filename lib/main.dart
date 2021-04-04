//@dart=2.9
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/Chats.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/Screens/Splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:selfcare/redux/middleware.dart';
import 'package:selfcare/redux/reducers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'Data/Notification.dart';

//Global ServiceLocator
GetIt getIt = GetIt.instance;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform = MethodChannel('high_importance_channel');
String selectedNotificationPayload;

Future<void> main() async {
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  final store = new Store(
    appStateReducer,
    middleware: [
      fetchUser,
      setDate,
      fetchPressure,
      fetchWeight,
      fetchUsers,
      fetchUserRecords,
      fetchChats,
      fetchTips
    ],
    initialState: new AppState(
        unreadList: <UnreadModel>[],
        users: <UserModel>[],
        chatsModel: MainChatsModel(),
        userModelEdit: UserModel(),
        selectTimeValuesWeight: BodyWeightModel(),
        selectTimeValuesPressure: BloodPressureModel(),
        selectTimeValues: BloodGlucoseModel(),
        selectedDateTimes: <String>[],
        bloodglucose: [],
        bloodpressure: [],
        bodyweight: [],
        userModel: UserModel(),
        userModelFetch: false,
        selectedDate: DateTime.now()),
  );
  getIt.registerSingleton<Store<AppState>>(store, signalsReady: true);
  WidgetsFlutterBinding.ensureInitialized();
  // await _configureLocalTimeZone();
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // String initialRoute = HomePage.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    // selectedNotificationPayload = notificationAppLaunchDetails!.payload;
    // initialRoute = SecondPage.routeName;
  }
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  // This widget is the root of your application.
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({this.store});

// TODO :

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      child: MaterialApp(
        title: 'SelfCare',
        home: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Text('An Error occured');
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return Splash();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return CircularProgressIndicator();
          },
        ),
      ),
      store: store,
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName =
      await platform.invokeMethod<String>('getTimeZoneName');
  log(timeZoneName);
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}
