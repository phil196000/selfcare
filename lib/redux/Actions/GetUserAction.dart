import 'package:selfcare/Data/UserModel.dart';

class GetUserAction {
  final String? email;

  GetUserAction({this.email});
}

class GetUserActionSuccess {
  final UserModel? userModelUser;

  GetUserActionSuccess({this.userModelUser});
}