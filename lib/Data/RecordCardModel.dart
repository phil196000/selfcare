import 'package:flutter/material.dart';

class RecordCardModel {
  final String title;
  final String poster;
  final Color background;

  RecordCardModel(this.title, this.poster, this.background);

  RecordCardModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        poster = json['poster'],
        background = json['background'];

  Map<String, dynamic> toJson() =>
      {'name': title, 'poster': poster, 'background': background};
}
