// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      (json['id'] as num).toInt(),
      (json['ice_bucket_id'] as num?)?.toInt(),
      json['image'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'ice_bucket_id': instance.ice_bucket_id,
      'image': instance.image,
    };
