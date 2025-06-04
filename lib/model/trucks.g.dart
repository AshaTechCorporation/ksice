// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trucks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trucks _$TrucksFromJson(Map<String, dynamic> json) => Trucks(
      (json['id'] as num).toInt(),
      json['code'] as String?,
      json['name'] as String?,
      (json['driver_id'] as num?)?.toInt(),
      json['license_plate'] as String?,
      json['image'] as String?,
      (json['is_active'] as num?)?.toInt(),
      (json['routes'] as List<dynamic>?)
          ?.map((e) => Routes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrucksToJson(Trucks instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'driver_id': instance.driver_id,
      'license_plate': instance.license_plate,
      'image': instance.image,
      'is_active': instance.is_active,
      'routes': instance.routes,
    };
