import 'dart:developer';

import 'package:selfcare/redux/Actions/GetBodyWeightAction.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';
import 'package:selfcare/redux/middleware.dart';

import 'Actions/GetUserAction.dart';
import 'AppState.dart';

AppState appStateReducer(AppState state, action) {
  if (action is GetUserAction) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        userModelFetch: true,
        selectedDateTimes: state.selectedDateTimes,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is GetUserActionSuccess) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModelFetch: false,
        userModel: action.userModelUser);
  } else if (action is AddGlucoseAction) {
    log(state.userModel!.user_id);
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
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
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        selectedDate: action.selected,
        userModelFetch: false,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is SelectedDateActionSuccess) {
    log(action.selectedTimes.toString(), name: 'last');

    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: action.selectedTimes,
        selectedDate: action.selected,
        userModelFetch: false,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is GetGlucoseAction) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        userModelFetch: true,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is GetGlucoseActionSuccess) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        userModelFetch: true,
        selectedDate: state.selectedDate,
        bloodglucose: action.glucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is GetPressureAction) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        userModelFetch: true,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is GetPressureActionSuccess) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        userModelFetch: true,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: action.pressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is GetWeightAction) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        userModelFetch: true,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is GetWeightActionSuccess) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        userModelFetch: true,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: action.weight,
        userModel: state.userModel);
  } else if (action is SelectTimeValuesAction) {
    return new AppState(
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        userModelFetch: true,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModel: state.userModel);
  } else if (action is SelectTimeValuesActionSuccess) {
    log('message');
    // log(action.selected!.created_at.toString(),name: 'select time values');
    if (action.selected != null) {
      log('success glucose');
      return new AppState(
          selectTimeValuesWeight: state.selectTimeValuesWeight,
          selectTimeValues: action.selected,
          selectTimeValuesPressure: state.selectTimeValuesPressure,
          selectedDateTimes: state.selectedDateTimes,
          userModelFetch: true,
          selectedDate: state.selectedDate,
          bloodglucose: state.bloodglucose,
          bloodpressure: state.bloodpressure,
          bodyweight: state.bodyweight,
          userModel: state.userModel);
    } else if (action.selectedPressure != null) {
      return new AppState(
          selectTimeValuesWeight: state.selectTimeValuesWeight,
          selectTimeValues: state.selectTimeValues,
          selectTimeValuesPressure: action.selectedPressure,
          selectedDateTimes: state.selectedDateTimes,
          userModelFetch: true,
          selectedDate: state.selectedDate,
          bloodglucose: state.bloodglucose,
          bloodpressure: state.bloodpressure,
          bodyweight: state.bodyweight,
          userModel: state.userModel);
    } else if (action.selectedWeight != null) {
      return new AppState(
          selectTimeValuesWeight: action.selectedWeight,
          selectTimeValues: state.selectTimeValues,
          selectTimeValuesPressure: state.selectTimeValuesPressure,
          selectedDateTimes: state.selectedDateTimes,
          userModelFetch: true,
          selectedDate: state.selectedDate,
          bloodglucose: state.bloodglucose,
          bloodpressure: state.bloodpressure,
          bodyweight: state.bodyweight,
          userModel: state.userModel);
    }
  }

  log(state.userModel!.user_id);
  // log(state.themeModel.background.toString());
  return state;
}
