import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/productunits.dart';

part 'productcategory.g.dart';

@JsonSerializable()
class ProductCategory {
  final int id;
  String? code;
  int? product_category_id;
  String? name;
  String? description;
  String? image;
  int? is_active;
  List<ProductUnits>? product_units;

  ProductCategory(
    this.id,
    this.code,
    this.product_category_id,
    this.name,
    this.description,
    this.image,
    this.is_active,
    this.product_units,
  );

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}
