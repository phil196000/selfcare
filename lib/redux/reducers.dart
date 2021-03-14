import 'dart:developer';

import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/middleware.dart';

import 'Actions/GetUserAction.dart';
import 'AppState.dart';

AppState appStateReducer(AppState state, action) {
  if (action is GetUserAction) {
    return new AppState(
        userModelFetch: true,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is GetUserActionSuccess) {
    return new AppState(
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModelFetch: false,
        userModel: action.userModelUser);
  } else if (action is AddGlucoseAction) {
    log(state.userModel!.user_id);
    return new AppState(
        selectedDate: state.selectedDate,
        userModelFetch: false,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is SelectedDateAction) {
    log('selected action');
    // log(SelectedDateAction().selected!.toString());
    return new AppState(
        selectedDate: action.selected,
        userModelFetch: false,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  }

  log(state.userModel!.user_id);
  // log(state.themeModel.background.toString());
  return state;
}
