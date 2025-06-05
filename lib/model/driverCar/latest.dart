import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/routePoints.dart';
import 'package:ksice/model/routes.dart';

part 'latest.g.dart';

@JsonSerializable()
class Latest {
  String? latitude;
  String? longitude;
  String? image;
  Routes? route;
  RoutePoints? route_point;
  DateTime? checked_in_at;
  int? distance_meters;

  Latest(
    this.latitude,
    this.longitude,
    this.image,
    this.route,
    this.route_point,
    this.checked_in_at,
    this.distance_meters,
  );

  factory Latest.fromJson(Map<String, dynamic> json) => _$LatestFromJson(json);

  Map<String, dynamic> toJson() => _$LatestToJson(this);
}
