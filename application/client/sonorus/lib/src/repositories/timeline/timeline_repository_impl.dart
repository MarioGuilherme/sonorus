import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository.dart";

class TimelineRepositoryImpl implements TimelineRepository {
  final HttpClient _httpClient;

  TimelineRepositoryImpl(this._httpClient);

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().get("/posts");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<PostModel>((post) => PostModel.fromMap(post)).toList();
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<int> likePostAsync(int idPost) async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().post("/posts/$idPost/like");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data as int;
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<int> likeCommentAsync(int commentId) async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().post("/comments/$commentId/like");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data as int;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<CommentModel>> loadCommentsAsync(int idPost) async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().get("/posts/$idPost/comments");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<CommentModel>((comment) => CommentModel.fromMap(comment)).toList();
    } on DioException {
      rethrow;
    }
  }
}