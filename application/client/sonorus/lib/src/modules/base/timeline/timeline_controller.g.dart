// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimelineController on TimelineControllerBase, Store {
  late final _$_timelineStatusAtom =
      Atom(name: 'TimelineControllerBase._timelineStatus', context: context);

  TimelineStateStatus get timelineStatus {
    _$_timelineStatusAtom.reportRead();
    return super._timelineStatus;
  }

  @override
  TimelineStateStatus get _timelineStatus => timelineStatus;

  @override
  set _timelineStatus(TimelineStateStatus value) {
    _$_timelineStatusAtom.reportWrite(value, super._timelineStatus, () {
      super._timelineStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'TimelineControllerBase._errorMessage', context: context);

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$_postsAtom =
      Atom(name: 'TimelineControllerBase._posts', context: context);

  List<PostModel> get posts {
    _$_postsAtom.reportRead();
    return super._posts;
  }

  @override
  List<PostModel> get _posts => posts;

  @override
  set _posts(List<PostModel> value) {
    _$_postsAtom.reportWrite(value, super._posts, () {
      super._posts = value;
    });
  }

  late final _$_commentsOfOpenedPostAtom = Atom(
      name: 'TimelineControllerBase._commentsOfOpenedPost', context: context);

  List<CommentModel> get commentsOfOpenedPost {
    _$_commentsOfOpenedPostAtom.reportRead();
    return super._commentsOfOpenedPost;
  }

  @override
  List<CommentModel> get _commentsOfOpenedPost => commentsOfOpenedPost;

  @override
  set _commentsOfOpenedPost(List<CommentModel> value) {
    _$_commentsOfOpenedPostAtom.reportWrite(value, super._commentsOfOpenedPost,
        () {
      super._commentsOfOpenedPost = value;
    });
  }

  late final _$getPostsAsyncAction =
      AsyncAction('TimelineControllerBase.getPosts', context: context);

  @override
  Future<void> getPosts({bool contentByPreference = true}) {
    return _$getPostsAsyncAction
        .run(() => super.getPosts(contentByPreference: contentByPreference));
  }

  late final _$saveCommentAsyncAction =
      AsyncAction('TimelineControllerBase.saveComment', context: context);

  @override
  Future<void> saveComment(int postId, String content) {
    return _$saveCommentAsyncAction
        .run(() => super.saveComment(postId, content));
  }

  late final _$likePostByIdAsyncAction =
      AsyncAction('TimelineControllerBase.likePostById', context: context);

  @override
  Future<int> likePostById(int postId) {
    return _$likePostByIdAsyncAction.run(() => super.likePostById(postId));
  }

  late final _$likeCommentByIdAsyncAction =
      AsyncAction('TimelineControllerBase.likeCommentById', context: context);

  @override
  Future<int> likeCommentById(int commentId) {
    return _$likeCommentByIdAsyncAction
        .run(() => super.likeCommentById(commentId));
  }

  late final _$loadCommentsAsyncAction =
      AsyncAction('TimelineControllerBase.loadComments', context: context);

  @override
  Future<void> loadComments(int postId) {
    return _$loadCommentsAsyncAction.run(() => super.loadComments(postId));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
