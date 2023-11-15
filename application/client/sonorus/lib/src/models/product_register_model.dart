// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

import "package:image_picker/image_picker.dart";
import "package:sonorus/src/models/condition_type.dart";

class ProductRegisterModel {
  final int? productId;
  final String name;
  final String description;
  final double price;
  final ConditionType condition;
  final List<XFile>? medias;

  ProductRegisterModel({
    this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.condition,
    this.medias
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "productId": productId,
      "name": name,
      "description": description,
      "price": price,
      "condition": condition.id,
      "medias": medias
    };
  }

  factory ProductRegisterModel.fromMap(Map<String, dynamic> map) {
    return ProductRegisterModel(
      productId: map["productId"] == null ? null : map["productId"] as int,
      name: map["name"] as String,
      description: map["description"] as String,
      price: map["price"] as double,
      condition: ConditionType.parse(map["condition"] as int)
    );
  }

  String toJson() => json.encode(this.toMap());

  factory ProductRegisterModel.fromJson(String source) => ProductRegisterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}