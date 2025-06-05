

import 'package:json_annotation/json_annotation.dart';

part 'productunits.g.dart';

@JsonSerializable()
class ProductUnits {
  final int id;
  String? price;
  int? product_id;
  String? name;
  String? weight_kg;
  String? image;
  int? is_active;

  ProductUnits(
    this.id,
    this.price,
    this.product_id,
    this.name,
    this.weight_kg,
    this.image,
    this.is_active,  
    
  );

  factory ProductUnits.fromJson(Map<String, dynamic> json) => _$ProductUnitsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductUnitsToJson(this);
}
