import "package:dio/dio.dart";
import "package:sonorus/src/core/exceptions/timeout_exception.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_with_author_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository.dart";

class TimelineRepositoryImpl implements TimelineRepository {
  final HttpClient _httpClient;

  TimelineRepositoryImpl(this._httpClient);

  @override
  Future<List<PostWithAuthorModel>> getMoreEightPosts(int offset, bool contentByPreference) async {
    try {
      final Response result = await _httpClient.postMS().auth().get(
        "/posts",
        options: Options(
          headers: {
            "offset": offset,
            "contentByPreference": contentByPreference
          }
        )
      );
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<PostWithAuthorModel>((post) => PostWithAuthorModel.fromMap(post)).toList();
    } on DioException catch (ex) {
      if([ DioExceptionType.sendTimeout, DioExceptionType.connectionTimeout, DioExceptionType.receiveTimeout ].contains(ex.type))
        throw TimeoutException(message: "O servidor demorou muito para responder.");

      rethrow;
    }
  }
  
  @override
  Future<int> likePost(int idPost) async {
    try {
      final Response result = await _httpClient.postMS().auth().post("/postLikers/$idPost");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data as int;
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<int> likeComment(int commentId) async {
    try {
      final Response result = await _httpClient.postMS().auth().post("/commentLikers/$commentId");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data as int;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<CommentModel>> loadComments(int postId) async {
    try {
      final Response result = await _httpClient.postMS().auth().get("/posts/$postId/comments");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<CommentModel>((comment) => CommentModel.fromMap(comment)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<CommentModel> saveComment(int postId, String content) async {
    try {
      final Response result = await _httpClient.postMS().auth().post("/comments", data: {
        "postId": postId,
        "content": content
      });
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return CommentModel.fromMap(restResponse.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deletePost(int postId) async {
    try {
      final Response result = await _httpClient.postMS().auth().delete("/posts/$postId");
      if (result.statusCode != 204)
        throw Exception("Falha ao excluir a publicação");
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(int commentId) async {
    try {
      final Response result = await _httpClient.postMS().auth().delete("/comments/$commentId");
      if (result.statusCode != 204)
        throw Exception("Falha ao excluir o comentário");
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> updateComment(int commentId, String newContent) async {
    try {
      final Response result = await _httpClient.postMS().auth().patch("/comments/$commentId", data: "\"$newContent\"");
      if (result.statusCode != 204)
        throw Exception("Falha ao atualizar o comentário");
    } on DioException {
      rethrow;
    }
  }
}