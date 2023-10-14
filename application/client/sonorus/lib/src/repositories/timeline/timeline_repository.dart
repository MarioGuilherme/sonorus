import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";

abstract interface class TimelineRepository {
  Future<List<PostModel>> getPosts();
  Future<int> likePostAsync(int idPost);
  Future<int> likeCommentAsync(int idComment);
  Future<List<CommentModel>> loadCommentsAsync(int idPost);
}