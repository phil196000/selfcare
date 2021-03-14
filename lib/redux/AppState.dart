import 'package:selfcare/Data/UserModel.dart';

class AppState {
  final List bloodglucose;
  final List bloodpressure;
  final List bodyweight;
  final UserModel? userModel;
  final bool userModelFetch;
  final DateTime? selectedDate;

  AppState({
    this.selectedDate,
    this.userModel,
    this.userModelFetch = false,
    this.bloodglucose = const [],
    this.bloodpressure = const [],
    this.bodyweight = const [],
  });
}
