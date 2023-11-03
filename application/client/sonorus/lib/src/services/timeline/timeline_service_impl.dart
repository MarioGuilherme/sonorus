import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository.dart";
import "package:sonorus/src/services/timeline/timeline_service.dart";

class TimelineServiceImpl implements TimelineService {
  final TimelineRepository _timelineRepository;

  TimelineServiceImpl(this._timelineRepository);

  @override
  Future<List<PostModel>> getPosts(bool contentByPreference) async => this._timelineRepository.getPosts(contentByPreference);
  
  @override
  Future<int> likePostById(int idPost) async => this._timelineRepository.likePostAsync(idPost);

  @override
  Future<int> likeCommentById(int commentId) async => this._timelineRepository.likeCommentAsync(commentId);

  @override
  Future<List<CommentModel>> loadComments(int idPost) async => this._timelineRepository.loadCommentsAsync(idPost);

  @override
  Future<CommentModel> saveComment(int postId, String content) async => this._timelineRepository.saveComment(postId, content);
}