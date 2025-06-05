// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driverCar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverCar _$DriverCarFromJson(Map<String, dynamic> json) => DriverCar(
      (json['id'] as num).toInt(),
      json['code'] as String?,
      json['name'] as String?,
      json['phone'] as String?,
      (json['trucks'] as List<dynamic>?)
          ?.map((e) => Trucks.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['No'] as num?)?.toInt(),
      json['latest_checkin'] == null
          ? null
          : Latest.fromJson(json['latest_checkin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DriverCarToJson(DriverCar instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'phone': instance.phone,
      'trucks': instance.trucks,
      'No': instance.No,
      'latest_checkin': instance.latest_checkin,
    };
