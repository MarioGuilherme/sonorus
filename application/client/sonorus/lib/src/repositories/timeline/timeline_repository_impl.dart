// import "package:dio/dio.dart";
// import "package:sonorus/src/core/http/http_client.dart";
// import "package:sonorus/src/models/rest_response_model.dart";
// import "package:sonorus/src/repositories/timeline/timeline_repository.dart";

// class TimelineRepositoryImpl implements TimelineRepository {
//   final HttpClient _httpClient;

//   @override
//   Future<void> getPosts() {
//     try {
//       final Response result = await _httpClient.postMicrosservice().unauth().get("/");
//       final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
//       return restResponse.data.map<InterestModel>((interest) => InterestModel.fromMap(interest)).toList();
//     } on DioException {
//       rethrow;
//     }
//   }
// }