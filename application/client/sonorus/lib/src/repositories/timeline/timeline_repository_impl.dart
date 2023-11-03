import "package:dio/dio.dart";
import "package:sonorus/src/core/exceptions/timeout_exception.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository.dart";

class TimelineRepositoryImpl implements TimelineRepository {
  final HttpClient _httpClient;

  TimelineRepositoryImpl(this._httpClient);

  @override
  Future<List<PostModel>> getPosts(bool contentByPreference) async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().get(
        "/posts",
        options: Options(
          headers: {
            "contentByPreference": contentByPreference
          }
        )
      );
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<PostModel>((post) => PostModel.fromMap(post)).toList();
    } on DioException catch (ex) {
      if([ DioExceptionType.sendTimeout, DioExceptionType.connectionTimeout, DioExceptionType.receiveTimeout ].contains(ex.type))
        throw TimeoutException(message: "O servidor demorou muito para responder.");

      rethrow;
    }
  }
  
  @override
  Future<int> likePostAsync(int idPost) async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().post("/postLikers/$idPost");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data as int;
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<int> likeCommentAsync(int commentId) async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().post("/commentLikers/$commentId");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data as int;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<CommentModel>> loadCommentsAsync(int postId) async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().get("/posts/$postId/comments");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<CommentModel>((comment) => CommentModel.fromMap(comment)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<CommentModel> saveComment(int postId, String content) async {
    try {
      final Response result = await _httpClient.postMicrosservice().auth().post("/posts/$postId/comments", data: {
        "content": content
      });
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return CommentModel.fromMap(restResponse.data);
    } on DioException {
      rethrow;
    }
  }
}