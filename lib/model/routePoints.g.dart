// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routePoints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutePoints _$RoutePointsFromJson(Map<String, dynamic> json) => RoutePoints(
      (json['id'] as num).toInt(),
      (json['route_id'] as num?)?.toInt(),
      (json['member_id'] as num?)?.toInt(),
      (json['member_branch_id'] as num?)?.toInt(),
      json['expected_time'] as String?,
      json['note'] as String?,
      json['latitude'] as String?,
      json['longitude'] as String?,
      (json['is_active'] as num?)?.toInt(),
      json['member_branch'] == null
          ? null
          : MaberBranch.fromJson(json['member_branch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoutePointsToJson(RoutePoints instance) =>
    <String, dynamic>{
      'id': instance.id,
      'route_id': instance.route_id,
      'member_id': instance.member_id,
      'member_branch_id': instance.member_branch_id,
      'expected_time': instance.expected_time,
      'note': instance.note,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_active': instance.is_active,
      'member_branch': instance.member_branch,
    };
