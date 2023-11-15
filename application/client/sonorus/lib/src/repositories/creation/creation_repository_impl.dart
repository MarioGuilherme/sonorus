import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";
import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/models/opportunity_model_register.dart";
import "package:sonorus/src/models/post_register_model.dart";
import "package:sonorus/src/models/post_with_author_model.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/models/product_register_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/creation/creation_repository.dart";

class CreationRepositoryImpl implements CreationRepository {
  final HttpClient _httpClient;

  CreationRepositoryImpl(this._httpClient);

  @override
  Future<void> createPost(PostRegisterModel newPost) async {
    try {
      final FormData formData = FormData.fromMap({
        "content": newPost.content,
        "tablature": newPost.tablature,
        "interestsIds": newPost.interestsIds
      });
      formData.files.addAll(newPost.medias.map((media) => MapEntry("medias", MultipartFile.fromFileSync(media.path))));
      final Response result = await _httpClient.postMS().auth().post("/posts", data: formData);
      if (result.statusCode != 204)
        throw Exception("Falha ao criar a publicação");
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ProductModel> createProduct(ProductRegisterModel product, List<XFile> medias) async {
    try {
      final FormData formData = FormData.fromMap({
        "name": product.name,
        "description": product.description,
        "price": product.price.toString().replaceAll(".", ","),
        "condition": product.condition.id
      });
      formData.files.addAll(medias.map((media) => MapEntry("medias", MultipartFile.fromFileSync(media.path))));
      final Response result = await _httpClient.marketplaceMS().auth().post("/products", data: formData);
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return ProductModel.fromMap(restResponse.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> updateProduct(ProductRegisterModel product, List<XFile> medias) async {
    try {
      final List<String> mediasToKeep = medias
        .where((m) => !m.path.startsWith("/"))
        .map((m) => m.path).toList();
      final List<XFile> mediasToCreate = medias
        .where((m) => m.path.startsWith("/"))
        .toList();
      final FormData formData = FormData.fromMap({
        "productId": product.productId,
        "name": product.name,
        "description": product.description,
        "price": product.price.toString().replaceAll(".", ","),
        "condition": product.condition.id,
        "mediasToKeep": mediasToKeep
      });
      formData.files.addAll(mediasToCreate.map((media) => MapEntry("medias", MultipartFile.fromFileSync(media.path))));
      final Response result = await _httpClient.marketplaceMS().auth().patch("/products", data: formData);
      if (result.statusCode != 204)
        throw Exception("Falha ao editar o anúncio");
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<OpportunityModel> createOpportunity(OpportunityRegisterModel opportunity) async {
    try {
      final Map<String, dynamic> formData = {
        "name": opportunity.name,
        "bandName": opportunity.bandName,
        "description": opportunity.description,
        "experienceRequired": opportunity.experienceRequired,
        "isWork": opportunity.isWork,
        "workTimeUnit": opportunity.workTimeUnit.id
      };
      if (opportunity.payment != null)
        formData.addAll({ "payment": opportunity.payment });

      final Response result = await _httpClient.businessMS().auth().post("/opportunities", data: formData);

      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return OpportunityModel.fromMap(restResponse.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> updateOpportunity(OpportunityRegisterModel opportunity) async {
    try {
      final Map<String, dynamic> formData = {
        "opportunityId": opportunity.opportunityId,
        "name": opportunity.name,
        "bandName": opportunity.bandName,
        "description": opportunity.description,
        "experienceRequired": opportunity.experienceRequired,
        "isWork": opportunity.isWork,
        "workTimeUnit": opportunity.workTimeUnit.id
      };
      if (opportunity.payment != null)
        formData.addAll({ "payment": opportunity.payment });

      final Response result = await _httpClient.businessMS().auth().patch("/opportunities", data: formData);
      if (result.statusCode != 204)
        throw Exception("Falha ao editar a oportundade");
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<InterestModel>> getAllInterests() async {
    try {
      final Response result = await _httpClient.accountMS().unauth().get("/interests");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<InterestModel>((interest) => InterestModel.fromMap(interest)).toList();
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<void> updatePost(PostRegisterModel post, List<XFile> medias) async {
    try {
      final List<String> mediasToKeep = medias
        .where((m) => !m.path.startsWith("/"))
        .map((m) => m.path).toList();
      final List<XFile> mediasToCreate = medias
        .where((m) => m.path.startsWith("/"))
        .toList();
      final FormData formData = FormData.fromMap({
        "postId": post.postId,
        "content": post.content,
        "tablature": post.tablature,
        "interestsIds": post.interestsIds,
        "mediasToKeep": mediasToKeep
      });
      formData.files.addAll(mediasToCreate.map((media) => MapEntry("medias", MultipartFile.fromFileSync(media.path))));
      final Response result = await _httpClient.postMS().auth().patch("/posts", data: formData);
      if (result.statusCode != 204)
        throw Exception("Falha ao editar a publicação");
    } on DioException {
      rethrow;
    }
  }
}