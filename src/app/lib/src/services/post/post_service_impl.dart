import "package:image_picker/image_picker.dart";

import "package:sonorus/src/core/extensions/trim_or_null_extension.dart";
import "package:sonorus/src/dtos/input_models/create_comment_input_model.dart";
import "package:sonorus/src/dtos/input_models/create_post_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_comment_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_post_input_model.dart";
import "package:sonorus/src/dtos/view_models/comment_view_model.dart";
import "package:sonorus/src/dtos/view_models/post_view_model.dart";
import "package:sonorus/src/repositories/post/post_repository.dart";
import "package:sonorus/src/services/post/post_service.dart";

class PostServiceImpl implements PostService {
  final PostRepository _repository;

  PostServiceImpl(this._repository);

  @override
  Future<int> likePost(int postId) async => this._repository.likePost(postId);

  @override
  Future<int> likeComment(int postId, int commentId) async => this._repository.likeComment(postId, commentId);

  @override
  Future<List<PostViewModel>> getPagedPosts(bool contentByPreference, int offset, int limit) => this._repository.getPagedPosts(contentByPreference, offset, limit);
  
  @override
  Future<List<CommentViewModel>> getAllCommentsByPostId(int postId) async => this._repository.getAllCommentsByPostId(postId);

  @override
  Future<CommentViewModel> createComment(int postId, String content) async {
    final CreateCommentInputModel inputModel = CreateCommentInputModel(content: content.trim());
    final CommentViewModel commentViewModel = await this._repository.createComment(postId, inputModel);
    return commentViewModel;
  }

  @override
  Future<void> savePost(int? postId, String? content, String? tablature, List<int> interestsIds, List<XFile> newMedias, List<int>? mediasToRemove) async {
    if (postId == null) {
      final CreatePostInputModel inputModel = CreatePostInputModel(
        content: content.trimOrNull(),
        tablature: tablature,
        medias: newMedias,
        interestsIds: interestsIds
      );
      return this._repository.createPost(inputModel);
    }

    final UpdatePostInputModel inputModel = UpdatePostInputModel(
      content: content.trimOrNull(),
      tablature: tablature,
      newMedias: newMedias,
      interestsIds: interestsIds,
      mediasToRemove: mediasToRemove!
    );
    await this._repository.updatePost(postId, inputModel);
  }

  @override
  Future<void> deletePostById(int postId) => this._repository.deletePostById(postId);

  @override
  Future<void> deleteCommentById(int postId, int commentId) => this._repository.deleteCommentById(postId, commentId);

  @override
  Future<void> updateComment(int postId, int commentId, String content) async {
    final UpdateCommentInputModel inputModel = UpdateCommentInputModel(content: content);
    await this._repository.updateComment(postId, commentId, inputModel);
  }
}