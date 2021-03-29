
import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/RecordsModel.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';

class GetUserRecordsAction {
  final String? user_id;

  GetUserRecordsAction({this.user_id});
}

class GetGlucoseRecordsActionSuccess {
  final List<MainBloodGlucoseModel> glucoseRecords ;

  GetGlucoseRecordsActionSuccess({this.glucoseRecords=const <MainBloodGlucoseModel>[]});
}

class GetPressureRecordsActionSuccess {
  final List<MainBloodPressureModel> pressureRecords;

  GetPressureRecordsActionSuccess({this.pressureRecords=const <MainBloodPressureModel>[]});
}
class GetWeightRecordsActionSuccess {
  final List<MainBodyWeightModel> weightRecords;

  GetWeightRecordsActionSuccess({this.weightRecords=const <MainBodyWeightModel>[]});
}
