import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/Chats.dart';
import 'package:selfcare/Data/HealthTip.dart';
import 'package:selfcare/Data/RatingsModel.dart';
import 'package:selfcare/Data/RecordsModel.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';
import 'package:selfcare/Screens/Admin/Rating.dart';

class AppState {
  final List<UserModel>? users;
  final List? bloodglucose;
  final List? bloodpressure;
  final List? bodyweight;
  final UserModel? userModel;
  final bool userModelFetch;
  final DateTime? selectedDate;
  final List<String>? selectedDateTimes;
  final MainBloodGlucoseModel? selectedBloodGlucoseByDate;
  final BloodGlucoseModel? selectTimeValues;
  final BloodPressureModel? selectTimeValuesPressure;
  final BodyWeightModel? selectTimeValuesWeight;
  final UserModel? userModelEdit;
  final List<TipModel> tips;

// final RecordsModel? userRecords;
  final List<MainBloodGlucoseModel> glucoseRecords;
  final List<MainBloodPressureModel> pressureRecords;
  final List<MainBodyWeightModel> weightRecords;
  final MainChatsModel? chatsModel;
  final List<UnreadModel> unreadList;
  final List<RatingsModel> ratings;

  AppState({
    this.ratings = const <RatingsModel>[],
    this.tips = const <TipModel>[],
    this.unreadList = const <UnreadModel>[],
    this.chatsModel,
    this.glucoseRecords = const [],
    this.pressureRecords = const [],
    this.weightRecords = const [],
    // this.userRecords,
    this.userModelEdit,
    this.users = const <UserModel>[],
    this.selectTimeValuesWeight,
    this.selectTimeValuesPressure,
    this.selectTimeValues,
    this.selectedDateTimes = const <String>[],
    this.selectedBloodGlucoseByDate,
    this.selectedDate,
    this.userModel,
    this.userModelFetch = false,
    this.bloodglucose = const [],
    this.bloodpressure = const [],
    this.bodyweight = const [],
  });
}
