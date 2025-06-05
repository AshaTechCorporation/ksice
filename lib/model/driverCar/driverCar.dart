import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/driverCar/latest.dart';
import 'package:ksice/model/trucks.dart';

part 'driverCar.g.dart';

@JsonSerializable()
class DriverCar {
  final int id;
  String? code;
  String? name;
  String? phone;
  List<Trucks>? trucks;
  int? No;
  Latest? latest_checkin;

  DriverCar(
    this.id,
    this.code,
    this.name,
    this.phone,
    this.trucks,
    this.No,
    this.latest_checkin,
  );

  factory DriverCar.fromJson(Map<String, dynamic> json) => _$DriverCarFromJson(json);

  Map<String, dynamic> toJson() => _$DriverCarToJson(this);
}
