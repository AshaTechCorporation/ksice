// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Routes _$RoutesFromJson(Map<String, dynamic> json) => Routes(
      (json['id'] as num).toInt(),
      json['code'] as String?,
      json['name'] as String?,
      (json['truck_id'] as num?)?.toInt(),
      json['license_plate'] as String?,
      json['image'] as String?,
      (json['is_active'] as num?)?.toInt(),
      (json['route_points'] as List<dynamic>?)
          ?.map((e) => RoutePoints.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoutesToJson(Routes instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'truck_id': instance.truck_id,
      'license_plate': instance.license_plate,
      'image': instance.image,
      'is_active': instance.is_active,
      'route_points': instance.route_points,
    };
