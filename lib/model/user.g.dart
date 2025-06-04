// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['id'] as num).toInt(),
      json['code'] as String?,
      json['name'] as String?,
      json['username'] as String?,
      json['password'] as String?,
      json['phone'] as String?,
      json['image'] as String?,
      (json['is_active'] as num?)?.toInt(),
      (json['trucks'] as List<dynamic>?)
          ?.map((e) => Trucks.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'username': instance.username,
      'password': instance.password,
      'phone': instance.phone,
      'image': instance.image,
      'is_active': instance.is_active,
      'trucks': instance.trucks,
    };
