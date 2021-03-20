// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    age: json['age'] as int,
    gender: json['gender'] as String,
    country: json['country'] as String,
    created_at: json['created_at'] as int,
    is_active: json['is_active'] as bool,
    location: json['location'] as Map<String, dynamic>,
    password: json['password'] as String,
    phone_number: json['phone_number'] as String,
    roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    user_id: json['user_id'] as String,
    full_name: json['full_name'] as String,
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'full_name': instance.full_name,
      'email': instance.email,
      'age': instance.age,
      'country': instance.country,
      'is_active': instance.is_active,
      'password': instance.password,
      'phone_number': instance.phone_number,
      'roles': instance.roles,
      'location': instance.location,
      'created_at': instance.created_at,
      'user_id': instance.user_id,
      'gender': instance.gender,
    };
