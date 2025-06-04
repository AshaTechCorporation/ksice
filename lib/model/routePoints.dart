import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/maberBranch.dart';

part 'routePoints.g.dart';

@JsonSerializable()
class RoutePoints {
  final int id;
  int? route_id;
  int? member_id;
  int? member_branch_id;
  String? expected_time;
  String? note;
  String? latitude;
  String? longitude;
  int? is_active;
  MaberBranch? member_branch;

  RoutePoints(
    this.id,
    this.route_id,
    this.member_id,
    this.member_branch_id,
    this.expected_time,
    this.note,
    this.latitude,
    this.longitude,
    this.is_active,
    this.member_branch,
  );

  factory RoutePoints.fromJson(Map<String, dynamic> json) => _$RoutePointsFromJson(json);

  Map<String, dynamic> toJson() => _$RoutePointsToJson(this);
}
