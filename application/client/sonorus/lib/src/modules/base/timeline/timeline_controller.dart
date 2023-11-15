import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";
import "package:sonorus/src/core/exceptions/timeout_exception.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/post_with_author_model.dart";
import "package:sonorus/src/models/user_model.dart";
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
  loadingMorePosts,
  loadedMorePosts,
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
  List<PostWithAuthorModel> _posts = <PostWithAuthorModel>[];

  @readonly
  List<CommentModel> _commentsOfOpenedPost = <CommentModel>[];
  
  @readonly
  bool _contentByPreference = true;

  TimelineControllerBase(this._timelineService);

  @action
  Future<void> getFirstEightPosts({bool contentByPreference = true}) async {
    try {
      this._timelineStatus = TimelineStateStatus.loadingPosts;
      this._posts = await this._timelineService.getMoreEightPosts(0, contentByPreference);
      this._timelineStatus = TimelineStateStatus.loadedPosts;
    }  on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorPosts;
      log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> updateContentByPreference(bool value) async {
    this._contentByPreference = value;
  }

  @action
  Future<void> getMoreEightPosts(int offset, {bool contentByPreference = true}) async {
    try {
      this._timelineStatus = TimelineStateStatus.loadingMorePosts;
      final List<PostWithAuthorModel> moresPosts = await this._timelineService.getMoreEightPosts(offset, contentByPreference);
      this._timelineStatus = TimelineStateStatus.loadedMorePosts;
      this._posts.addAll(moresPosts);
    } on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorPosts;
      log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> saveComment(int postId, String content) async {
    try {
      this._timelineStatus = TimelineStateStatus.savingComment;
      final CurrentUserModel currentUser = Modular.get<CurrentUserModel>();
      final CommentModel newComment = await this._timelineService.saveComment(postId, content);
      newComment.author = UserModel(
        userId: currentUser.userId!,
        nickname: currentUser.nickname!,
        picture: currentUser.picture!
      );
      this._commentsOfOpenedPost.add(newComment);
      this._posts.firstWhere((post) => post.postId == postId).totalComments++;
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
  Future<void> loadCommentsByPostId(int postId) async {
    try {
      this._timelineStatus = TimelineStateStatus.loadingComments;
      this._commentsOfOpenedPost = await this._timelineService.loadComments(postId);
      this._timelineStatus = TimelineStateStatus.loadedComments;
    } on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorLoadComments;
      log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> deleteComment(int postId, int commentId) async {
    try {
      await this._timelineService.deleteComment(commentId);
      final int index = this._posts.indexWhere((post) => post.postId == postId);
      final PostWithAuthorModel postClone = PostWithAuthorModel(
        postId: postId,
        author: this._posts[index].author,
        content: this._posts[index].content,
        postedAt: this._posts[index].postedAt,
        totalLikes: this._posts[index].totalLikes,
        totalComments: this._posts[index].totalComments - 1,
        isLikedByMe: this._posts[index].isLikedByMe,
        medias: this._posts[index].medias,
        interests: this._posts[index].interests,
        tablature: this._posts[index].tablature
      );
      this._posts[index] = postClone;
      this._commentsOfOpenedPost = this._commentsOfOpenedPost.where((comment) => comment.commentId != commentId).toList();
    } on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorLoadComments;
      log("Erro ao deletar a publicação", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> deletePost(int postId) async {
    try {
      await this._timelineService.deletePost(postId);
      this._posts = this._posts.where((post) => post.postId != postId).toList();
    } on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorLoadComments;
      log("Erro ao deletar a publicação", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> updateComment(int commentId, String newContent) async {
    try {
      await this._timelineService.updateComment(commentId, newContent);
      final int index = this._commentsOfOpenedPost.indexWhere((comment) => comment.commentId == commentId);
      final CommentModel newComment = CommentModel(
        commentId: commentId,
        content: newContent,
        author: this._commentsOfOpenedPost[index].author,
        commentedAt: this._commentsOfOpenedPost[index].commentedAt,
        totalLikes: this._commentsOfOpenedPost[index].totalLikes,
        isLikedByMe: this._commentsOfOpenedPost[index].isLikedByMe
      );
      this._commentsOfOpenedPost = this._commentsOfOpenedPost.where((comment) => comment.commentId != commentId).toList();
      this._commentsOfOpenedPost.add(newComment);
    } on Exception catch (exception, stackTrace) {
      this._timelineStatus = TimelineStateStatus.errorLoadComments;
      log("Erro ao atualizar o comentário", error: exception, stackTrace: stackTrace);
    }
  }
}