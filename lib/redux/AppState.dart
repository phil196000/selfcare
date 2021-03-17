import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';

class AppState {
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


  AppState({
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
