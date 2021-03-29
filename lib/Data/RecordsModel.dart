import 'package:selfcare/Data/BloodPressure.dart';
import 'package:selfcare/Data/BodyWeight.dart';
import 'package:selfcare/Data/bloodglucosepost.dart';

class RecordsModel {
  final List<MainBloodGlucoseModel> glucose;
  final List<MainBloodPressureModel> pressure;
  final List<MainBodyWeightModel> weight;

  RecordsModel({this.glucose=const [], this.pressure =const [], this.weight=const []});

  RecordsModel.fromJson(Map<String, dynamic> json)
      : glucose = json['glucose'],
        weight = json['weight'],
        pressure = json['pressure'];

  Map<String, dynamic> toJson() =>
      {'glucose': glucose, 'pressure': pressure, 'weight': weight};
}
