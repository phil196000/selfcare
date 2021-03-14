import 'package:flutter/material.dart';

class SettingCardModel {
  final String title;
  final IconData avatar;
  final Color color;

  SettingCardModel(this.title, this.avatar, this.color);

  SettingCardModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        avatar = json['avatar'],
        color = json['color'];

  Map<String, dynamic> toJson() =>
      {'name': title, 'avatar': avatar, 'color': color};
}
