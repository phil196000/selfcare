import 'package:cloud_firestore/cloud_firestore.dart';

class BloodGlucoseModel {
  final double pre_meal;
  final double post_meal;
  final int created_at;
  final bool is_deleted;

  BloodGlucoseModel(
      { this.pre_meal=0.0,
       this.post_meal = 0.0,
      this.is_deleted = false,
       this.created_at=0});

  BloodGlucoseModel.fromJson(Map<String, dynamic> json)
      : pre_meal = double.parse(json['pre_meal'].toString()),
        is_deleted = json['is_deleted'],
        post_meal = double.parse(json['post_meal'].toString()),
        created_at = json['created_at'];

  Map<String, dynamic> toJson() => {
        'pre_meal': pre_meal,
        'post_meal': post_meal,
        'created_at': created_at,
        'is_deleted': is_deleted
      };
}

class MainBloodGlucoseModel {
  final String? date_for;
  final int? date_for_timestamp_millis;
  final List? readings;
  final bool is_deleted;

  MainBloodGlucoseModel(
      {this.date_for,
      this.date_for_timestamp_millis,
      this.readings,
      this.is_deleted = false});

  MainBloodGlucoseModel.fromJson(Map<String, dynamic> json)
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

class MainGlucoseModelwithID {
  final DocumentReference? id;
  final dynamic data;

  MainGlucoseModelwithID({this.id, this.data});

  MainGlucoseModelwithID.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        data = json['data'];

  Map<String, dynamic> toJson() => {'id': id, 'data': data};
}
