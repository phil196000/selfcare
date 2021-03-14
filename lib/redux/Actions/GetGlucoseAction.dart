class GetGlucoseAction {
  final String? user_id;

  GetGlucoseAction({this.user_id});
}

class GetGlucoseActionSuccess {
  final List userModelUser;

  GetGlucoseActionSuccess({this.userModelUser = const []});
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

  SelectedDateAction({this.selected});
}

class SelectedDateActionSuccess {
  final DateTime? selected;

  SelectedDateActionSuccess({this.selected});
}