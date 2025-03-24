// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostController on PostControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: 'PostControllerBase._status', context: context);

  PostPageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  PostPageStatus get _status => status;

  @override
  set _status(PostPageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_postsAtom =
      Atom(name: 'PostControllerBase._posts', context: context);

  ObservableList<PostViewModel> get posts {
    _$_postsAtom.reportRead();
    return super._posts;
  }

  @override
  ObservableList<PostViewModel> get _posts => posts;

  @override
  set _posts(ObservableList<PostViewModel> value) {
    _$_postsAtom.reportWrite(value, super._posts, () {
      super._posts = value;
    });
  }

  late final _$_commentsOfOpenedPostAtom =
      Atom(name: 'PostControllerBase._commentsOfOpenedPost', context: context);

  ObservableList<CommentViewModel> get commentsOfOpenedPost {
    _$_commentsOfOpenedPostAtom.reportRead();
    return super._commentsOfOpenedPost;
  }

  @override
  ObservableList<CommentViewModel> get _commentsOfOpenedPost =>
      commentsOfOpenedPost;

  @override
  set _commentsOfOpenedPost(ObservableList<CommentViewModel> value) {
    _$_commentsOfOpenedPostAtom.reportWrite(value, super._commentsOfOpenedPost,
        () {
      super._commentsOfOpenedPost = value;
    });
  }

  late final _$_contentByPreferenceAtom =
      Atom(name: 'PostControllerBase._contentByPreference', context: context);

  bool get contentByPreference {
    _$_contentByPreferenceAtom.reportRead();
    return super._contentByPreference;
  }

  @override
  bool get _contentByPreference => contentByPreference;

  @override
  set _contentByPreference(bool value) {
    _$_contentByPreferenceAtom.reportWrite(value, super._contentByPreference,
        () {
      super._contentByPreference = value;
    });
  }

  late final _$_offsetAtom =
      Atom(name: 'PostControllerBase._offset', context: context);

  int get offset {
    _$_offsetAtom.reportRead();
    return super._offset;
  }

  @override
  int get _offset => offset;

  @override
  set _offset(int value) {
    _$_offsetAtom.reportWrite(value, super._offset, () {
      super._offset = value;
    });
  }

  late final _$_showFormAtom =
      Atom(name: 'PostControllerBase._showForm', context: context);

  bool get showForm {
    _$_showFormAtom.reportRead();
    return super._showForm;
  }

  @override
  bool get _showForm => showForm;

  @override
  set _showForm(bool value) {
    _$_showFormAtom.reportWrite(value, super._showForm, () {
      super._showForm = value;
    });
  }

  late final _$_postIdAtom =
      Atom(name: 'PostControllerBase._postId', context: context);

  int? get postId {
    _$_postIdAtom.reportRead();
    return super._postId;
  }

  @override
  int? get _postId => postId;

  @override
  set _postId(int? value) {
    _$_postIdAtom.reportWrite(value, super._postId, () {
      super._postId = value;
    });
  }

  late final _$_oldMediasToRemoveAtom =
      Atom(name: 'PostControllerBase._oldMediasToRemove', context: context);

  ObservableList<int> get oldMediasToRemove {
    _$_oldMediasToRemoveAtom.reportRead();
    return super._oldMediasToRemove;
  }

  @override
  ObservableList<int> get _oldMediasToRemove => oldMediasToRemove;

  @override
  set _oldMediasToRemove(ObservableList<int> value) {
    _$_oldMediasToRemoveAtom.reportWrite(value, super._oldMediasToRemove, () {
      super._oldMediasToRemove = value;
    });
  }

  late final _$_newMediasAtom =
      Atom(name: 'PostControllerBase._newMedias', context: context);

  ObservableList<XFile> get newMedias {
    _$_newMediasAtom.reportRead();
    return super._newMedias;
  }

  @override
  ObservableList<XFile> get _newMedias => newMedias;

  @override
  set _newMedias(ObservableList<XFile> value) {
    _$_newMediasAtom.reportWrite(value, super._newMedias, () {
      super._newMedias = value;
    });
  }

  late final _$_oldMediasAtom =
      Atom(name: 'PostControllerBase._oldMedias', context: context);

  ObservableList<MediaViewModel> get oldMedias {
    _$_oldMediasAtom.reportRead();
    return super._oldMedias;
  }

  @override
  ObservableList<MediaViewModel> get _oldMedias => oldMedias;

  @override
  set _oldMedias(ObservableList<MediaViewModel> value) {
    _$_oldMediasAtom.reportWrite(value, super._oldMedias, () {
      super._oldMedias = value;
    });
  }

  late final _$_allTagsAtom =
      Atom(name: 'PostControllerBase._allTags', context: context);

  ObservableList<InterestDto> get allTags {
    _$_allTagsAtom.reportRead();
    return super._allTags;
  }

  @override
  ObservableList<InterestDto> get _allTags => allTags;

  @override
  set _allTags(ObservableList<InterestDto> value) {
    _$_allTagsAtom.reportWrite(value, super._allTags, () {
      super._allTags = value;
    });
  }

  late final _$_selectedTagsAtom =
      Atom(name: 'PostControllerBase._selectedTags', context: context);

  ObservableList<InterestDto> get selectedTags {
    _$_selectedTagsAtom.reportRead();
    return super._selectedTags;
  }

  @override
  ObservableList<InterestDto> get _selectedTags => selectedTags;

  @override
  set _selectedTags(ObservableList<InterestDto> value) {
    _$_selectedTagsAtom.reportWrite(value, super._selectedTags, () {
      super._selectedTags = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: 'PostControllerBase._error', context: context);

  String? get error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  String? get _error => error;

  @override
  set _error(String? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
    });
  }

  late final _$getPagedPostsAsyncAction =
      AsyncAction('PostControllerBase.getPagedPosts', context: context);

  @override
  Future<void> getPagedPosts() {
    return _$getPagedPostsAsyncAction.run(() => super.getPagedPosts());
  }

  late final _$createCommentAsyncAction =
      AsyncAction('PostControllerBase.createComment', context: context);

  @override
  Future<void> createComment(int postId, String content) {
    return _$createCommentAsyncAction
        .run(() => super.createComment(postId, content));
  }

  late final _$likePostByIdAsyncAction =
      AsyncAction('PostControllerBase.likePostById', context: context);

  @override
  Future<int> likePostById(int postId) {
    return _$likePostByIdAsyncAction.run(() => super.likePostById(postId));
  }

  late final _$likeCommentByIdAsyncAction =
      AsyncAction('PostControllerBase.likeCommentById', context: context);

  @override
  Future<int> likeCommentById(int postId, int commentId) {
    return _$likeCommentByIdAsyncAction
        .run(() => super.likeCommentById(postId, commentId));
  }

  late final _$loadCommentsByPostIdAsyncAction =
      AsyncAction('PostControllerBase.loadCommentsByPostId', context: context);

  @override
  Future<void> loadCommentsByPostId(int postId) {
    return _$loadCommentsByPostIdAsyncAction
        .run(() => super.loadCommentsByPostId(postId));
  }

  late final _$deleteCommentAsyncAction =
      AsyncAction('PostControllerBase.deleteComment', context: context);

  @override
  Future<void> deleteComment(int postId, int commentId) {
    return _$deleteCommentAsyncAction
        .run(() => super.deleteComment(postId, commentId));
  }

  late final _$deletePostAsyncAction =
      AsyncAction('PostControllerBase.deletePost', context: context);

  @override
  Future<void> deletePost(int postId) {
    return _$deletePostAsyncAction.run(() => super.deletePost(postId));
  }

  late final _$updateCommentAsyncAction =
      AsyncAction('PostControllerBase.updateComment', context: context);

  @override
  Future<void> updateComment(int postId, int commentId, String content) {
    return _$updateCommentAsyncAction
        .run(() => super.updateComment(postId, commentId, content));
  }

  late final _$showModalWithTagsAsyncAction =
      AsyncAction('PostControllerBase.showModalWithTags', context: context);

  @override
  Future<void> showModalWithTags() {
    return _$showModalWithTagsAsyncAction.run(() => super.showModalWithTags());
  }

  late final _$savePostAsyncAction =
      AsyncAction('PostControllerBase.savePost', context: context);

  @override
  Future<void> savePost(String? content, String? tablature) {
    return _$savePostAsyncAction.run(() => super.savePost(content, tablature));
  }

  late final _$PostControllerBaseActionController =
      ActionController(name: 'PostControllerBase', context: context);

  @override
  void toggleShowForm(bool? showForm) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.toggleShowForm');
    try {
      return super.toggleShowForm(showForm);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPostId(int? postId) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.setPostId');
    try {
      return super.setPostId(postId);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewMedias(List<XFile> newMedias) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.addNewMedias');
    try {
      return super.addNewMedias(newMedias);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetOffset() {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.resetOffset');
    try {
      return super.resetOffset();
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOffset(int? offset) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.setOffset');
    try {
      return super.setOffset(offset);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addOldMedias(List<MediaViewModel> oldMedias) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.addOldMedias');
    try {
      return super.addOldMedias(oldMedias);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeNewMedia(XFile newMedia) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.removeNewMedia');
    try {
      return super.removeNewMedia(newMedia);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeOldMedia(MediaViewModel oldMedia) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.removeOldMedia');
    try {
      return super.removeOldMedia(oldMedia);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleContentByPreference(bool value) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.toggleContentByPreference');
    try {
      return super.toggleContentByPreference(value);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSelectedTags(List<InterestDto> tags) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.addSelectedTags');
    try {
      return super.addSelectedTags(tags);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void associateTag(InterestDto tag) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.associateTag');
    try {
      return super.associateTag(tag);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void disassociateTag(InterestDto tag) {
    final _$actionInfo = _$PostControllerBaseActionController.startAction(
        name: 'PostControllerBase.disassociateTag');
    try {
      return super.disassociateTag(tag);
    } finally {
      _$PostControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
