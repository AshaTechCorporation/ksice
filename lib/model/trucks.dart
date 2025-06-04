import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/routes.dart';

part 'trucks.g.dart';

@JsonSerializable()
class Trucks {
  final int id;
  String? code;
  String? name;
  int? driver_id;
  String? license_plate;
  String? image;
  int? is_active;
  List<Routes>? routes;

  Trucks(
    this.id,
    this.code,
    this.name,
    this.driver_id,
    this.license_plate,
    this.image,
    this.is_active,
    this.routes,
  );

  factory Trucks.fromJson(Map<String, dynamic> json) => _$TrucksFromJson(json);

  Map<String, dynamic> toJson() => _$TrucksToJson(this);
}
