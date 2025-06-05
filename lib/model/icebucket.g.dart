// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icebucket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IceBucket _$IceBucketFromJson(Map<String, dynamic> json) => IceBucket(
      (json['id'] as num).toInt(),
      json['code'] as String?,
      json['size_name'] as String?,
      (json['qty'] as num?)?.toInt(),
      json['remark'] as String?,
      (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IceBucketToJson(IceBucket instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'size_name': instance.size_name,
      'qty': instance.qty,
      'remark': instance.remark,
      'images': instance.images,
    };
