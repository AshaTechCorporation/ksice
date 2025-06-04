// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maberBranch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaberBranch _$MaberBranchFromJson(Map<String, dynamic> json) => MaberBranch(
      (json['id'] as num).toInt(),
      json['code'] as String?,
      (json['member_id'] as num?)?.toInt(),
      json['name'] as String?,
      json['address'] as String?,
      json['province'] as String?,
      json['district'] as String?,
      json['sub_district'] as String?,
      json['postal_code'] as String?,
      json['latitude'] as String?,
      json['longitude'] as String?,
      json['contact_name'] as String?,
      json['contact_phone'] as String?,
      json['contact_phone2'] as String?,
      (json['is_active'] as num?)?.toInt(),
      json['member'] == null
          ? null
          : Member.fromJson(json['member'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MaberBranchToJson(MaberBranch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'member_id': instance.member_id,
      'name': instance.name,
      'address': instance.address,
      'province': instance.province,
      'district': instance.district,
      'sub_district': instance.sub_district,
      'postal_code': instance.postal_code,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'contact_name': instance.contact_name,
      'contact_phone': instance.contact_phone,
      'contact_phone2': instance.contact_phone2,
      'is_active': instance.is_active,
      'member': instance.member,
    };
