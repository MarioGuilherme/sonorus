import "package:sonorus/src/domain/enums/condition_type.dart";
import "package:sonorus/src/dtos/view_models/media_view_model.dart";
import "package:sonorus/src/dtos/view_models/user_view_model.dart";

class ProductViewModel {
  final int productId;
  final String name;
  final double price;
  final String? description;
  final ConditionType condition;
  final DateTime announcedAt;
  final UserViewModel seller;
  final List<MediaViewModel> medias;

  ProductViewModel({
    required this.productId,
    required this.name,
    required this.price,
    this.description,
    required this.condition,
    required this.announcedAt,
    required this.seller,
    required this.medias
  });

  factory ProductViewModel.fromMap(Map<String, dynamic> map) => ProductViewModel(
    productId: map["productId"] as int,
    name: map["name"] as String,
    price: double.parse(map["price"].toString()),
    description: map["description"] != null ? map["description"] as String : null,
    condition: ConditionType.parse(map["condition"] as int),
    announcedAt: DateTime.parse(map["announcedAt"] as String),
    seller: UserViewModel.fromMap(map["seller"] as Map<String, dynamic>),
    medias: List<MediaViewModel>.from(map["medias"].map((media) => MediaViewModel.fromMap(media)).toList())
  );
}