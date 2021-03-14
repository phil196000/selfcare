// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Navigation/BottomNav.dart';
import 'package:selfcare/Screens/AllStatistics.dart';
import 'package:selfcare/Screens/Login.dart';
import 'package:selfcare/Screens/Record.dart';
import 'package:selfcare/Screens/Welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:selfcare/redux/AppState.dart';
import 'package:selfcare/redux/middleware.dart';
import 'package:selfcare/redux/reducers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Global ServiceLocator
GetIt getIt = GetIt.instance;
// The default value is 40 MB. The threshold must be set to at least 1 MB,
// and can be set to Settings.CACHE_SIZE_UNLIMITED to disable garbage collection.

void main() {
  final store = new Store(
    appStateReducer,
    middleware: [fetchUser],
    initialState: new AppState(
      bloodglucose: [],
      bloodpressure: [],
      bodyweight: [],
      userModel: UserModel(),
      userModelFetch: false,
      selectedDate: DateTime.now()

    ),
  );
  getIt.registerSingleton<Store>(store, signalsReady: true);
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
              return Welcome();
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
