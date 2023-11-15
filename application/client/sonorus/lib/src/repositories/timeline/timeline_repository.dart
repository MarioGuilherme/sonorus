import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_with_author_model.dart";

abstract interface class TimelineRepository {
  Future<List<PostWithAuthorModel>> getMoreEightPosts(int offset, bool contentByPreference);
  Future<int> likePost(int postId);
  Future<int> likeComment(int commentId);
  Future<List<CommentModel>> loadComments(int idPost);
  Future<CommentModel> saveComment(int postId, String content);
  Future<void> deletePost(int postId);
  Future<void> deleteComment(int commentId);
  Future<void> updateComment(int commentId, String newContent);
}