import "dart:convert";

import "package:intl/intl.dart";

import "package:sonorus/src/models/condition_type.dart";
import "package:sonorus/src/models/media_model.dart";
import "package:sonorus/src/models/user_model.dart";

class ProductModel {
  final int productId;
  final String name;
  final String? description;
  final double price;
  final DateTime announcedAt;
  final ConditionType condition;
  final UserModel seller;
  final List<MediaModel> medias;

  ProductModel({
    required this.productId,
    required this.name,
    this.description,
    required this.price,
    required this.announcedAt,
    required this.condition,
    required this.seller,
    required this.medias
  });

  String get conditionString => switch (this.condition.id) {
    0 => "Novo",
    1 => "Semi-Usado",
    _ => "Usado"
  };

  String get formatedCurrency {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: "pt_BR",
      symbol: r"R$"
    );
    return currencyFormat.format(this.price);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "productId": productId,
      "name": name,
      "description": description,
      "price": price,
      "announcedAt": announcedAt.millisecondsSinceEpoch,
      "condition": condition.id,
      "seller": seller.toMap(),
      "medias": medias.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map["productId"] as int,
      name: map["name"] as String,
      description: map["description"] != null ? map["description"] as String : null,
      price: map["price"] as double,
      announcedAt: DateTime.parse(map["announcedAt"]),
      condition: ConditionType.parse(map["condition"]),
      seller: UserModel.fromMap(map["seller"] as Map<String, dynamic>),
      medias: List<MediaModel>.from(map["medias"].map((media) => MediaModel.fromMap(media)).toList())
    );
  }

  String toJson() => json.encode(this.toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}