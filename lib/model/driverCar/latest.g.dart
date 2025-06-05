// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Latest _$LatestFromJson(Map<String, dynamic> json) => Latest(
      json['latitude'] as String?,
      json['longitude'] as String?,
      json['image'] as String?,
      json['route'] == null
          ? null
          : Routes.fromJson(json['route'] as Map<String, dynamic>),
      json['route_point'] == null
          ? null
          : RoutePoints.fromJson(json['route_point'] as Map<String, dynamic>),
      json['checked_in_at'] == null
          ? null
          : DateTime.parse(json['checked_in_at'] as String),
      (json['distance_meters'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LatestToJson(Latest instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image': instance.image,
      'route': instance.route,
      'route_point': instance.route_point,
      'checked_in_at': instance.checked_in_at?.toIso8601String(),
      'distance_meters': instance.distance_meters,
    };
