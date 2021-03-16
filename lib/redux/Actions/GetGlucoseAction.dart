import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';

class GetGlucoseAction {
  final String? user_id;

  GetGlucoseAction({this.user_id});
}

class GetGlucoseActionSuccess {
  final List? glucose;

  GetGlucoseActionSuccess({this.glucose = const []});
}

class AddGlucoseAction {
  final String? user_id;

  AddGlucoseAction({this.user_id});
}

class AddGlucoseActionSuccess {
  final List userModelUser;

  AddGlucoseActionSuccess({this.userModelUser = const []});
}

class SelectedDateAction {
  final DateTime? selected;
  final String screen;

  SelectedDateAction({ this.screen='Blood Glucose', this.selected});
}

class SelectedDateActionSuccess {
  final DateTime? selected;
  final List<String>? selectedTimes;
  final String screen;
  SelectedDateActionSuccess({this.screen='Blood Glucose',this.selectedTimes, this.selected});
}

class SelectTimeValuesAction {
  final String? selected;
  final String screen;
  SelectTimeValuesAction({this.selected,this.screen ='Blood Glucose'});
}

class SelectTimeValuesActionSuccess {
  final BloodGlucoseModel? selected;
  final BloodPressureModel? selectedPressure;
  SelectTimeValuesActionSuccess({this.selected,this.selectedPressure});
}
