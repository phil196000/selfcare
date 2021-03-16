class GetPressureAction {
  final String? user_id;

  GetPressureAction({this.user_id});
}

class GetPressureActionSuccess {
  final List? pressure;

  GetPressureActionSuccess({this.pressure = const []});
}