import 'package:selfcare/Data/RatingsModel.dart';

class RatingsAction {
  RatingsAction();
}

class RatingsActionSuccess {
  List<RatingsModel> ratings;

  RatingsActionSuccess({this.ratings = const <RatingsModel>[]});
}
