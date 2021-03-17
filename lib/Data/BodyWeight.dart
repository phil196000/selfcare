import 'package:cloud_firestore/cloud_firestore.dart';

class BodyWeightModel {
  final int weight;
  final int created_at;
  final bool is_deleted;

  BodyWeightModel(
      {this.weight = 0, this.is_deleted = false, this.created_at = 0});

  BodyWeightModel.fromJson(Map<String, dynamic> json)
      : weight = json['weight'],
        is_deleted = json['is_deleted'],
        created_at = json['created_at'];

  Map<String, dynamic> toJson() =>
      {'weight': weight, 'created_at': created_at, 'is_deleted': is_deleted};
}

class MainBodyWeightModel {
  final String? date_for;
  final int? date_for_timestamp_millis;
  final List? readings;
  final bool is_deleted;

  MainBodyWeightModel(
      {this.date_for,
      this.date_for_timestamp_millis,
      this.readings,
      this.is_deleted = false});

  MainBodyWeightModel.fromJson(Map<String, dynamic> json)
      : date_for = json['date_for'],
        date_for_timestamp_millis = json['date_for_timestamp_millis'],
        is_deleted = json['is_deleted'],
        readings = json['readings'];

  Map<String, dynamic> toJson() => {
        'date_for': date_for,
        'is_deleted': is_deleted,
        'date_for_timestamp_millis': date_for_timestamp_millis,
        'readings': readings
      };
}

class MainWeightModelwithID {
  final DocumentReference? id;
  final dynamic data;

  MainWeightModelwithID({this.id, this.data});

  MainWeightModelwithID.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        data = json['data'];

  Map<String, dynamic> toJson() => {'id': id, 'data': data};
}
