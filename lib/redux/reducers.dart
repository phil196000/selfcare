import 'dart:developer';

import 'package:selfcare/Data/RecordsModel.dart';
import 'package:selfcare/redux/Actions/ChatActions.dart';
import 'package:selfcare/redux/Actions/GetBodyWeightAction.dart';
import 'package:selfcare/redux/Actions/GetGlucoseAction.dart';
import 'package:selfcare/redux/Actions/GetPressureAction.dart';
import 'package:selfcare/redux/Actions/GetRecordsAction.dart';
import 'package:selfcare/redux/Actions/GetUsersAction.dart';
import 'package:selfcare/redux/Actions/RatingsAction.dart';
import 'package:selfcare/redux/Actions/RatingsAction.dart';
import 'package:selfcare/redux/Actions/TipsAction.dart';
import 'package:selfcare/redux/middleware.dart';

import 'Actions/GetUserAction.dart';
import 'AppState.dart';

AppState appStateReducer(AppState state, action) {
  // log('reducer ran', name: 'reducer');
  if (action is RatingsAction) {
    // if (action.userEditModel!.user_id.length > 0)
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is RatingsActionSuccess) {
    // log(action.userEditModel!.user_id, name: 'get user edit');

    return new AppState(
        ratings: action.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is TipsAction) {
    // if (action.userEditModel!.user_id.length > 0)
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is TipsActionSuccess) {
    // log(action.userEditModel!.user_id, name: 'get user edit');

    return new AppState(
        ratings: state.ratings,
        tips: action.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is UnreadAction) {
    // if (action.userEditModel!.user_id.length > 0)
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is UnreadActionSuccess) {
    // log(action.userEditModel!.user_id, name: 'get user edit');

    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: action.unreads,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is ChatAction) {
    // if (action.userEditModel!.user_id.length > 0)
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is ChatActionSuccess) {
    // log(action.userEditModel!.user_id, name: 'get user edit');

    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: action.mainChatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is GetUserRecordsAction) {
    // if (action.userEditModel!.user_id.length > 0)
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is GetGlucoseRecordsActionSuccess) {
    // log(action.userEditModel!.user_id, name: 'get user edit');

    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: action.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is GetPressureRecordsActionSuccess) {
    // log(action.userEditModel!.user_id, name: 'get user edit');
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: action.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is GetWeightRecordsActionSuccess) {
    // log(action.userEditModel!.user_id, name: 'get user edit');

    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: action.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is GetUserEditAction) {
    // log(action.userEditModel!.user_id, name: 'get user edit');
    // if (action.userEditModel!.user_id.length > 0)
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is GetUserEditActionSuccess) {
    // log(action.userEditModel!.user_id, name: 'get user edit');
    if (action.userEditModel != null)
      return new AppState(
          ratings: state.ratings,
          tips: state.tips,
          unreadList: state.unreadList,
          chatsModel: state.chatsModel,
          glucoseRecords: state.glucoseRecords,
          pressureRecords: state.pressureRecords,
          weightRecords: state.weightRecords,
          userModelEdit: action.userEditModel,
          users: state.users,
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
  } else if (action is GetUsersAction) {
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        userModelEdit: state.userModelEdit,
        users: state.users,
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
  } else if (action is GetUsersActionSuccess) {
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: action.users,
        userModelEdit: state.userModelEdit,
        selectTimeValuesWeight: state.selectTimeValuesWeight,
        selectTimeValuesPressure: state.selectTimeValuesPressure,
        selectTimeValues: state.selectTimeValues,
        selectedDateTimes: state.selectedDateTimes,
        selectedDate: state.selectedDate,
        bloodglucose: state.bloodglucose,
        bloodpressure: state.bloodpressure,
        bodyweight: state.bodyweight,
        userModelFetch: false,
        userModel: state.userModel);
  } else if (action is GetUserAction) {
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
    // log(state.userModel!.user_id);
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
    // log('selected action');
    // log(SelectedDateAction().selected!.toString());
    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
    // log(action.selectedTimes.toString(), name: 'last');

    return new AppState(
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        glucoseRecords: state.glucoseRecords,
        pressureRecords: state.pressureRecords,
        weightRecords: state.weightRecords,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
        ratings: state.ratings,
        tips: state.tips,
        unreadList: state.unreadList,
        chatsModel: state.chatsModel,
        users: state.users,
        userModelEdit: state.userModelEdit,
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
    // log('message');
    // log(action.selected!.created_at.toString(),name: 'select time values');
    if (action.selected != null) {
      // log('success glucose');
      return new AppState(
          ratings: state.ratings,
          tips: state.tips,
          unreadList: state.unreadList,
          chatsModel: state.chatsModel,
          users: state.users,
          userModelEdit: state.userModelEdit,
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
          ratings: state.ratings,
          tips: state.tips,
          unreadList: state.unreadList,
          chatsModel: state.chatsModel,
          users: state.users,
          userModelEdit: state.userModelEdit,
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
          ratings: state.ratings,
          tips: state.tips,
          unreadList: state.unreadList,
          chatsModel: state.chatsModel,
          users: state.users,
          userModelEdit: state.userModelEdit,
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

  // log(state.userModel!.user_id, name: 'user model before state is returned');
  // log(state.userModelEdit!.user_id, name: 'user edit model last');
  // log(state.themeModel.background.toString());
  return state;
}
