import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";

abstract interface class TimelineService {
  Future<List<PostModel>> getPosts();
  Future<int> likePostById(int postId);
  Future<int> likeCommentById(int commentId);
  Future<List<CommentModel>> loadComments(int idPost);
}