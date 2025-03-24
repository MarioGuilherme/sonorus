import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/domain/exceptions/authenticated_user_are_not_owner_of_comment_exception.dart";
import "package:sonorus/src/domain/exceptions/authenticated_user_are_not_owner_of_post_exception.dart";
import "package:sonorus/src/domain/exceptions/comment_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/post_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/post_or_comment_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/input_models/create_comment_input_model.dart";
import "package:sonorus/src/dtos/input_models/create_post_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_comment_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_post_input_model.dart";
import "package:sonorus/src/dtos/view_models/comment_view_model.dart";
import "package:sonorus/src/dtos/view_models/post_view_model.dart";
import "package:sonorus/src/repositories/post/post_repository.dart";

class PostRepositoryImpl implements PostRepository {
  final HttpClient _httpClient;

  PostRepositoryImpl(this._httpClient);

  @override
  Future<void> deleteCommentById(int postId, int commentId) async {
    try {
      await this._httpClient.auth().delete("/posts/$postId/comments/$commentId");
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 403) throw AuthenticatedUserAreNotOwnerOfCommentException();
        if (exception.response?.statusCode == 404) throw CommentNotFoundException();
      }
      throw RepositoryException();
    }
  }

  @override
  Future<void> deletePostById(int postId) async {
    try {
      await this._httpClient.auth().delete("/posts/$postId");
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 403) throw AuthenticatedUserAreNotOwnerOfPostException();
        if (exception.response?.statusCode == 404) throw PostNotFoundException();
      }
      throw RepositoryException();
    }
  }

  @override
  Future<List<PostViewModel>> getPagedPosts(bool contentByPreference, int offset, int limit) async {
    try {
      final Response result = await this._httpClient.auth().get("/posts", queryParameters: {
        "contentByPreference": contentByPreference,
        "offset": offset,
        "limit": limit
      });
      return result.data.map<PostViewModel>((post) => PostViewModel.fromMap(post)).toList();
    } on Exception {
      throw RepositoryException();
    }
  }

  @override
  Future<int> likeComment(int postId, int commentId) async {
    try {
      final Response result = await this._httpClient.auth().patch("/posts/$postId/comments/$commentId/likers");
      return result.data as int;
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 404) throw PostOrCommentNotFoundException();
      throw RepositoryException();
    }
  }

  @override
  Future<int> likePost(int postId) async {
    try {
      final Response result = await this._httpClient.auth().patch("/posts/$postId/likers");
      return result.data as int;
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 404) throw PostNotFoundException();
      throw RepositoryException();
    }
  }

  @override
  Future<List<CommentViewModel>> getAllCommentsByPostId(int postId) async {
    try {
      final Response result = await this._httpClient.auth().get("/posts/$postId/comments");
      return result.data.map<CommentViewModel>((comment) => CommentViewModel.fromMap(comment)).toList();
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 404) throw PostNotFoundException();
      throw RepositoryException();
    }
  }

  @override
  Future<CommentViewModel> createComment(int postId, CreateCommentInputModel inputModel) async {
    try {
      final Response result = await this._httpClient.auth().post("/posts/$postId/comments", data: inputModel.toJson());
      return CommentViewModel.fromMap(result.data);
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
        if (exception.response?.statusCode == 404) throw PostNotFoundException();
      }
      throw RepositoryException();
    }
  }

  @override
  Future<void> updateComment(int postId, int commentId, UpdateCommentInputModel inputModel) async {
    try {
      await this._httpClient.auth().patch("/posts/$postId/comments/$commentId", data: inputModel.toJson());
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
        if (exception.response?.statusCode == 403) throw AuthenticatedUserAreNotOwnerOfCommentException();
        if (exception.response?.statusCode == 404) throw PostOrCommentNotFoundException();
      }
      throw RepositoryException();
    }
  }

  @override
  Future<void> createPost(CreatePostInputModel inputModel) async {
    try {
      await this._httpClient.auth().post("/posts", data: inputModel.toFormData());
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
      throw RepositoryException();
    }
  }

  @override
  Future<void> updatePost(int postId, UpdatePostInputModel inputModel) async {
    try {
      await this._httpClient.auth().patch("/posts/$postId", data: inputModel.toFormData());
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
        if (exception.response?.statusCode == 403) throw AuthenticatedUserAreNotOwnerOfPostException();
        if (exception.response?.statusCode == 404) throw PostNotFoundException();
      }
      throw RepositoryException();
    }
  }
}