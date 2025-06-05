// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productcategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) =>
    ProductCategory(
      (json['id'] as num).toInt(),
      json['code'] as String?,
      (json['product_category_id'] as num?)?.toInt(),
      json['name'] as String?,
      json['description'] as String?,
      json['image'] as String?,
      (json['is_active'] as num?)?.toInt(),
      (json['product_units'] as List<dynamic>?)
          ?.map((e) => ProductUnits.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'product_category_id': instance.product_category_id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'is_active': instance.is_active,
      'product_units': instance.product_units,
    };
