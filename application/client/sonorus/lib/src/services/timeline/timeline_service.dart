import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_with_author_model.dart";

abstract interface class TimelineService {
  Future<List<PostWithAuthorModel>> getMoreEightPosts(int offset, bool contentByPreference);
  Future<int> likePostById(int postId);
  Future<int> likeCommentById(int commentId);
  Future<List<CommentModel>> loadComments(int postId);
  Future<CommentModel> saveComment(int postId, String content);
  Future<void> deletePost(int postId);
  Future<void> deleteComment(int commentId);
  Future<void> updateComment(int commentId, String newContent);
}