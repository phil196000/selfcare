import 'package:cloud_firestore/cloud_firestore.dart';

class BloodPressureModel {
  final double systolic;
  final double diastolic;
  final int created_at;
  final bool is_deleted;

  BloodPressureModel(
      {this.systolic = 0,
      this.diastolic = 0,
      this.is_deleted = false,
      this.created_at = 0});

  BloodPressureModel.fromJson(Map<String, dynamic> json)
      : systolic = double.parse(json['systolic'].toString()),
        is_deleted = json['is_deleted'],
        diastolic = double.parse(json['diastolic'].toString()),
        created_at = json['created_at'];

  Map<String, dynamic> toJson() => {
        'systolic': systolic,
        'diastolic': diastolic,
        'created_at': created_at,
        'is_deleted': is_deleted
      };
}

class MainBloodPressureModel {
  final String? date_for;
  final int? date_for_timestamp_millis;
  final List? readings;
  final bool is_deleted;

  MainBloodPressureModel(
      {this.date_for,
      this.date_for_timestamp_millis,
      this.readings,
      this.is_deleted = false});

  MainBloodPressureModel.fromJson(Map<String, dynamic> json)
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

class MainPressureModelwithID {
  final DocumentReference? id;
  final dynamic data;

  MainPressureModelwithID({this.id, this.data});

  MainPressureModelwithID.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        data = json['data'];

  Map<String, dynamic> toJson() => {'id': id, 'data': data};
}
