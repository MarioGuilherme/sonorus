import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository.dart";
import "package:sonorus/src/services/timeline/timeline_service.dart";

class TimelineServiceImpl implements TimelineService {
  final TimelineRepository _timelineRepository;

  TimelineServiceImpl(this._timelineRepository);

  @override
  Future<List<PostModel>> getPosts() async => this._timelineRepository.getPosts();
  
  @override
  Future<int> likePostById(int idPost) async => this._timelineRepository.likePostAsync(idPost);

  @override
  Future<int> likeCommentById(int commentId) async => this._timelineRepository.likeCommentAsync(commentId);

  @override
  Future<List<CommentModel>> loadComments(int idPost) async => this._timelineRepository.loadCommentsAsync(idPost);
}