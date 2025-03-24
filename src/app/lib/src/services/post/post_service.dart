import "package:image_picker/image_picker.dart";

import "package:sonorus/src/dtos/view_models/comment_view_model.dart";
import "package:sonorus/src/dtos/view_models/post_view_model.dart";

abstract interface class PostService {
  Future<void> deleteCommentById(int postId, int commentId);
  Future<void> deletePostById(int postId);
  Future<List<PostViewModel>> getPagedPosts(bool contentByPreference, int offset, int limit);
  Future<int> likeComment(int postId, int commentId);
  Future<int> likePost(int postId);
  Future<void> savePost(int? postId, String? content, String? tablature, List<int> interestsIds, List<XFile> newMedias, List<int>? mediasToRemove);
  Future<List<CommentViewModel>> getAllCommentsByPostId(int postId);
  Future<CommentViewModel> createComment(int postId, String content);
  Future<void> updateComment(int postId, int commentId, String newContent);
}