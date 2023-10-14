import "dart:developer";

import "package:mobx/mobx.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/services/timeline/timeline_service.dart";

part "timeline_controller.g.dart";

class TimelineController = TimelineControllerBase with _$TimelineController;

enum TimelineStateStatus {
  initial,
  loading,
  success,
  error
}

abstract class TimelineControllerBase with Store {
  final TimelineService _timelineService;

  @readonly
  TimelineStateStatus _timelineStatus = TimelineStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  List<PostModel> _posts = <PostModel>[];

  TimelineControllerBase(this._timelineService);

  Future<void> getPosts() async {
    try {
      this._timelineStatus = TimelineStateStatus.loading;
      this._posts = await this._timelineService.getPosts();
      this._timelineStatus = TimelineStateStatus.success;
    } on Exception catch (exception, stackTrace) {
      log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<int> likePostById(int postId) async {
    try {
      return await this._timelineService.likePostById(postId);
    } on Exception catch (exception, stackTrace) {
      log("Erro ao curtir a publicação", error: exception, stackTrace: stackTrace);
      return 0;
    }
  }

  @action
  Future<int> likeCommentById(int commentId) async {
    try {
      return await this._timelineService.likeCommentById(commentId);
    } on Exception catch (exception, stackTrace) {
      log("Erro ao curtir a publicação", error: exception, stackTrace: stackTrace);
      return 0;
    }
  }

  @action
  Future<List<CommentModel>> loadComments(int postId) async {
    try {
      return await this._timelineService.loadComments(postId);
    } on Exception catch (exception, stackTrace) {
      log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
      return [];
    }
  }
}