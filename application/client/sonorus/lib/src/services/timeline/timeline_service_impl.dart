import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_with_author_model.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository.dart";
import "package:sonorus/src/services/timeline/timeline_service.dart";

class TimelineServiceImpl implements TimelineService {
  final TimelineRepository _timelineRepository;

  TimelineServiceImpl(this._timelineRepository);

  @override
  Future<List<PostWithAuthorModel>> getMoreEightPosts(int offset, bool contentByPreference) async => this._timelineRepository.getMoreEightPosts(offset, contentByPreference);
  
  @override
  Future<int> likePostById(int idPost) async => this._timelineRepository.likePost(idPost);

  @override
  Future<int> likeCommentById(int commentId) async => this._timelineRepository.likeComment(commentId);

  @override
  Future<List<CommentModel>> loadComments(int idPost) async => this._timelineRepository.loadComments(idPost);

  @override
  Future<CommentModel> saveComment(int postId, String content) async => this._timelineRepository.saveComment(postId, content);

  @override
  Future<void> deletePost(int postId) async => this._timelineRepository.deletePost(postId);

  @override
  Future<void> deleteComment(int commentId) async => this._timelineRepository.deleteComment(commentId);

  @override
  Future<void> updateComment(int commentId, String newContent) async => this._timelineRepository.updateComment(commentId, newContent);
}