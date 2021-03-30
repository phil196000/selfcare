import 'package:selfcare/Data/HealthTip.dart';

class TipsAction {
  TipsAction();
}

class TipsActionSuccess {
  List<TipModel> tips;

  TipsActionSuccess({this.tips=const <TipModel>[]});
}
