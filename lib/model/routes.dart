import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/routePoints.dart';

part 'routes.g.dart';

@JsonSerializable()
class Routes {
  final int id;
  String? code;
  String? name;
  int? truck_id;
  String? license_plate;
  String? image;
  int? is_active;
  List<RoutePoints>? route_points;

  Routes(
    this.id,
    this.code,
    this.name,
    this.truck_id,
    this.license_plate,
    this.image,
    this.is_active,
    this.route_points,
  );

  factory Routes.fromJson(Map<String, dynamic> json) => _$RoutesFromJson(json);

  Map<String, dynamic> toJson() => _$RoutesToJson(this);
}
