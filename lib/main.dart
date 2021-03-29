// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:redux/redux.dart';
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

//Global ServiceLocator
GetIt getIt = GetIt.instance;
// The default value is 40 MB. The threshold must be set to at least 1 MB,
// and can be set to Settings.CACHE_SIZE_UNLIMITED to disable garbage collection.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
// BehaviorSubject<ReceivedNotification>();
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
//
// String? selectedNotificationPayload;
void main() {
  final store = new Store(
    appStateReducer,
    middleware: [
      fetchUser,
      setDate,
      fetchPressure,
      fetchWeight,
      fetchUsers,
      fetchUserRecords,
      fetchChats
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
