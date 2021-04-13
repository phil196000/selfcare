import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'UserModel.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class UserModel {
  UserModel(
      {this.age = 0,
      this.added_by = '',
      this.updated = const [],
      this.gender = '',
      this.country = '',
      this.created_at = 0,
      this.is_active = false,
      this.location = const {},
      this.password = '',
      this.phone_number = '',
      this.roles = const [],
      this.user_id = '',
      this.full_name = '',
      this.online = true,
      this.tokens,
      this.email = ''});

  bool online;
  String full_name;
  String email;
  int age;
  String country;
  bool is_active;
  String password;
  String phone_number;
  List<String> roles;
  Map location;
  int created_at;
  String user_id;
  String gender;
  String added_by;
  List updated;
  List<String>? tokens;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
