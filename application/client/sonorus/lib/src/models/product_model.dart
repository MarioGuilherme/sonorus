import "dart:convert";

import "package:sonorus/src/models/media_model.dart";
import "package:sonorus/src/models/user_model.dart";

class ProductModel {
  final int productId;
  final String name;
  final String? description;
  final double price;
  final DateTime announcedAt;
  final UserModel seller;
  final List<MediaModel> medias;

  ProductModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.announcedAt,
    required this.seller,
    required this.medias,
    this.description
  });
  
  String get timeAgo {
    final DateTime now = DateTime.now();

    final int differenceSeconds = now.difference(this.announcedAt).inSeconds;
    if (differenceSeconds <= 59)
      return "$differenceSeconds segundos atrás";

    final int differenceMinutes = now.difference(this.announcedAt).inMinutes;
    if (differenceMinutes <= 59)
      return "$differenceMinutes minutos atrás";

    final int differenceHours = now.difference(this.announcedAt).inHours;
    if (differenceHours <= 23)
      return "$differenceHours minutos atrás";

    final int differenceDays = now.difference(this.announcedAt).inDays;
    if (differenceDays <= 30)
      return "$differenceDays dias atrás";

    return "${this.announcedAt.day.toString().padLeft(2, "0")}/${this.announcedAt.month.toString().padLeft(2, "0")}/${this.announcedAt.year}";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "productId": productId,
      "name": name,
      "description": description,
      "price": price,
      "announcedAt": announcedAt.millisecondsSinceEpoch,
      "seller": seller.toMap(),
      "medias": medias.map((media) => media.toMap()).toList()
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map["productId"] as int,
      name: map["name"] as String,
      description: map["description"] != null ? map["description"] as String : null,
      price: map["price"] as double,
      announcedAt: DateTime.parse(map["announcedAt"]),
      seller: UserModel.fromMap(map["seller"] as Map<String,dynamic>),
      medias: List<MediaModel>.from(map["medias"].map((media) => MediaModel.fromMap(media)).toList())
    );
  }

  String toJson() => json.encode(this.toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}