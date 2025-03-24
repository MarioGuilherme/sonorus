import "package:sonorus/src/dtos/input_models/create_comment_input_model.dart";
import "package:sonorus/src/dtos/input_models/create_post_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_comment_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_post_input_model.dart";
import "package:sonorus/src/dtos/view_models/comment_view_model.dart";
import "package:sonorus/src/dtos/view_models/post_view_model.dart";

abstract interface class PostRepository {
  Future<void> deleteCommentById(int postId, int commentId);
  Future<void> deletePostById(int postId);
  Future<List<CommentViewModel>> getAllCommentsByPostId(int postId);
  Future<int> likeComment(int postId, int commentId);
  Future<int> likePost(int postId);
  Future<void> createPost(CreatePostInputModel inputModel);
  Future<void> updatePost(int postId, UpdatePostInputModel inputModel);
  Future<List<PostViewModel>> getPagedPosts(bool contentByPreference, int offset, int limit);
  Future<CommentViewModel> createComment(int postId, CreateCommentInputModel inputModel);
  Future<void> updateComment(int postId, int commentId, UpdateCommentInputModel inputModel);
}