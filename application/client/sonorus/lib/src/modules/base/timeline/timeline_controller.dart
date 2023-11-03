import "dart:developer";

import "package:mobx/mobx.dart";
import "package:sonorus/src/core/exceptions/timeout_exception.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/services/timeline/timeline_service.dart";

part "timeline_controller.g.dart";

class TimelineController = TimelineControllerBase with _$TimelineController;

enum TimelineStateStatus {
  initial,
  savingComment,
  savedComment,
  loadingComments,
  loadedComments,
  loadingPosts,
  loadedPosts,
  errorLoadComments,
  errorSaveComment,
  errorPosts
}

abstract class TimelineControllerBase with Store {
  final TimelineService _timelineService;

  @readonly
  TimelineStateStatus _timelineStatus = TimelineStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  List<PostModel> _posts = <PostModel>[];

  @readonly
  List<CommentModel> _commentsOfOpenedPost = <CommentModel>[];

  TimelineControllerBase(this._timelineService);

  @action
  Future<void> getPosts({bool contentByPreference = true}) async {
    try {
      this._timelineStatus = TimelineStateStatus.loadingPosts;
      this._posts = await this._timelineService.getPosts(contentByPreference);
      this._timelineStatus = TimelineStateStatus.loadedPosts;
    }  on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorPosts;
      log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
    }
    // on TimeoutException catch (exception, stackTrace) {
    //   log(exception.message, error: exception, stackTrace: stackTrace);
    //   this._errorMessage = exception.message;
    //   this._timelineStatus = TimelineStateStatus.error;
    // } on Exception catch (exception, stackTrace) {
    //   log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
    //   this._timelineStatus = TimelineStateStatus.error;
    // }
  }

  @action
  Future<void> saveComment(int postId, String content) async {
    try {
      this._timelineStatus = TimelineStateStatus.savingComment;
      this._commentsOfOpenedPost.add(await this._timelineService.saveComment(postId, content));
      this._timelineStatus = TimelineStateStatus.savedComment;
    } on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorSaveComment;
      log("Erro ao curtir a publicação", error: exception, stackTrace: stackTrace);
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
  Future<void> loadComments(int postId) async {
    try {
      this._timelineStatus = TimelineStateStatus.loadingComments;
      this._commentsOfOpenedPost = await this._timelineService.loadComments(postId);
      this._timelineStatus = TimelineStateStatus.loadedComments;
    } on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorLoadComments;
      log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
    }
  }
}