class GetWeightAction {
  final String user_id;

  GetWeightAction({this.user_id=''});
}

class GetWeightActionSuccess {
  final List? weight;

  GetWeightActionSuccess({this.weight = const []});
}
