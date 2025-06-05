// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productunits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductUnits _$ProductUnitsFromJson(Map<String, dynamic> json) => ProductUnits(
      (json['id'] as num).toInt(),
      json['price'] as String?,
      (json['product_id'] as num?)?.toInt(),
      json['name'] as String?,
      json['weight_kg'] as String?,
      json['image'] as String?,
      (json['is_active'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductUnitsToJson(ProductUnits instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'product_id': instance.product_id,
      'name': instance.name,
      'weight_kg': instance.weight_kg,
      'image': instance.image,
      'is_active': instance.is_active,
    };
