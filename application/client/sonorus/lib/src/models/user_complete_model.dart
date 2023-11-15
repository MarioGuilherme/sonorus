import "dart:convert";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/models/post_base_model.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/models/user_model.dart";

class UserCompleteModel extends UserModel {
  final String email;
  final List<InterestModel> interests;
  final List<PostBaseModel> posts;
  final List<OpportunityModel> opportunities;
  final List<ProductModel> products;

  UserCompleteModel({
    required super.userId,
    required super.nickname,
    required super.picture,
    required this.email,
    required this.interests,
    required this.posts,
    required this.opportunities,
    required this.products
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      "email": email,
      "interests": interests.map((x) => x.toMap()).toList(),
      "posts": posts.map((x) => x.toMap()).toList(),
      "opportunities": opportunities.map((x) => x.toMap()).toList(),
      "products": products.map((x) => x.toMap()).toList()
    };
  }

  factory UserCompleteModel.fromMap(Map<String, dynamic> map) {
    return UserCompleteModel(
      userId: map["userId"] as int,
      nickname: map["nickname"] as String,
      email: map["email"] as String,
      picture: map["picture"] as String,
      interests: List<InterestModel>.from(map["interests"].map((interest) => InterestModel.fromMap(interest)).toList()),
      posts: List<PostBaseModel>.from(map["posts"].map((post) => PostBaseModel.fromMap(post)).toList()),
      opportunities: List<OpportunityModel>.from(map["opportunities"].map((opportunity) => OpportunityModel.fromMap(opportunity)).toList()),
      products: List<ProductModel>.from(map["products"].map((product) => ProductModel.fromMap(product)).toList())
    );
  }

  @override
  String toJson() => json.encode(this.toMap());

  factory UserCompleteModel.fromJson(String source) => UserCompleteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}