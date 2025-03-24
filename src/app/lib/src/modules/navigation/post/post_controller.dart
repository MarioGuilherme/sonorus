// ignore_for_file: unused_field, prefer_final_fields
import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/domain/exceptions/authenticated_user_are_not_owner_of_post_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/post_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/dtos/view_models/comment_view_model.dart";
import "package:sonorus/src/dtos/view_models/media_view_model.dart";
import "package:sonorus/src/dtos/view_models/post_view_model.dart";
import "package:sonorus/src/dtos/view_models/user_view_model.dart";
import "package:sonorus/src/services/interest/interest_service.dart";
import "package:sonorus/src/services/post/post_service.dart";

part "post_controller.g.dart";

class PostController = PostControllerBase with _$PostController;

enum PostPageStatus {
  initial,
  savingPost,
  savedPost,
  creatingComment,
  createdComment,
  loadingComments,
  loadedComments,
  loadingPosts,
  loadedPosts,
  loadingAllTags,
  loadedAllTags,
  deletingPost,
  deletedPost,
  updatingComment,
  updatedComment,
  deletingComment,
  deletedComment,
  error
}

abstract class PostControllerBase with Store {
  final PostService _postService;
  final InterestService _interestService;
  final int _limit = 2;

  @readonly
  PostPageStatus _status = PostPageStatus.initial;

  @readonly
  ObservableList<PostViewModel> _posts = ObservableList();

  @readonly
  ObservableList<CommentViewModel> _commentsOfOpenedPost = ObservableList();
  
  @readonly
  bool _contentByPreference = true;

  @readonly
  int _offset = 0;
  
  @readonly
  bool _showForm = false;

  @readonly
  int? _postId;

  @readonly
  ObservableList<int> _oldMediasToRemove = ObservableList();

  @readonly
  ObservableList<XFile> _newMedias = ObservableList<XFile>();

  @readonly
  ObservableList<MediaViewModel> _oldMedias = ObservableList<MediaViewModel>();

  @readonly
  ObservableList<InterestDto> _allTags = ObservableList<InterestDto>();

  @readonly
  ObservableList<InterestDto> _selectedTags = ObservableList<InterestDto>();

  @readonly
  String? _error;

  PostControllerBase(this._postService, this._interestService);

  @action
  void toggleShowForm(bool? showForm) {
    this._showForm = showForm ?? !this._showForm;
    this._offset = 0;
    this._contentByPreference = true;
  }

  @action
  void setPostId(int? postId) => this._postId = postId;

  @action
  void addNewMedias(List<XFile> newMedias) => this._newMedias.addAll(newMedias);

  @action
  void resetOffset() => this._offset = 0;

  @action
  void setOffset(int? offset) => this._offset += offset ?? (this._posts.isEmpty ? 0 : this._posts.length);

  @action
  void addOldMedias(List<MediaViewModel> oldMedias) => this._oldMedias.addAll(oldMedias);

  @action
  void removeNewMedia(XFile newMedia) => this._newMedias.remove(newMedia);

  @action
  void removeOldMedia(MediaViewModel oldMedia) {
    this._oldMedias.remove(oldMedia);
    this._oldMediasToRemove.add(oldMedia.mediaId);
  }

  @action
  void toggleContentByPreference(bool value) => this._contentByPreference = value;

  @action
  void addSelectedTags(List<InterestDto> tags) => this._selectedTags.addAll(tags);

  @action
  void associateTag(InterestDto tag) => this._selectedTags.add(tag);

  @action
  void disassociateTag(InterestDto tag) => this._selectedTags.remove(tag);

  @action
  Future<void> getPagedPosts() async {
    try {
      this._status = PostPageStatus.loadingPosts;

      if (this._offset == 0) this._posts.clear();
      this._posts.addAll(await this._postService.getPagedPosts(this._contentByPreference, this._offset, this._limit));

      this._status = PostPageStatus.loadedPosts;
    } on Exception catch (exception, stackTrace) {
      this._status = PostPageStatus.error;
      log("Erro ao buscar as publicações", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> createComment(int postId, String content) async {
    try {
      this._status = PostPageStatus.creatingComment;

      final CommentViewModel commentViewModel = await this._postService.createComment(postId, content);
      this._posts.firstWhere((post) => post.postId == postId).totalComments++;

      final AuthenticatedUser authenticatedUser = Modular.get<AuthenticatedUser>();
      commentViewModel.author = UserViewModel(
        userId: authenticatedUser.userId!,
        nickname: authenticatedUser.nickname!,
        picture: authenticatedUser.picture!
      );
      this._commentsOfOpenedPost.add(commentViewModel);

      this._status = PostPageStatus.createdComment;
    } on Exception catch (exception, stackTrace) {
      this._status = PostPageStatus.error;
      log("Erro ao criar comentário!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<int> likePostById(int postId) async {
    try {
      return await this._postService.likePost(postId);
    } on Exception catch (exception, stackTrace) {
      log("Erro ao curtir a publicação $postId!", error: exception, stackTrace: stackTrace);
      return -1;
    }
  }

  @action
  Future<int> likeCommentById(int postId, int commentId) async {
    try {
      return await this._postService.likeComment(postId, commentId);
    } on Exception catch (exception, stackTrace) {
      log("Erro ao curtir o comentário $commentId!", error: exception, stackTrace: stackTrace);
      return -1;
    }
  }

  @action
  Future<void> loadCommentsByPostId(int postId) async {
    try {
      this._status = PostPageStatus.loadingComments;

      this._commentsOfOpenedPost.clear();
      this._commentsOfOpenedPost.addAll(await this._postService.getAllCommentsByPostId(postId));

      this._status = PostPageStatus.loadedComments;
    } on Exception catch (exception, stackTrace) {
      this._status = PostPageStatus.error;
      log("Erro ao buscar os comentários da publicação $postId", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> deleteComment(int postId, int commentId) async {
    try {
      this._status = PostPageStatus.deletingComment;

      await this._postService.deleteCommentById(postId, commentId);
      final int index = this._posts.indexWhere((post) => post.postId == postId);
      this._posts[index].totalComments = this._posts[index].totalComments - 1;
      this._commentsOfOpenedPost.removeWhere((comment) => comment.commentId != commentId);

      this._status = PostPageStatus.deletedComment;
    } on Exception catch (exception, stackTrace) {
      this._status = PostPageStatus.error;
      log("Erro ao deletar o comentário $commentId", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> deletePost(int postId) async {
    try {
      this._status = PostPageStatus.deletingPost;

      await this._postService.deletePostById(postId);
      this._posts.removeWhere((post) => post.postId != postId);

      this._status = PostPageStatus.deletedPost;
    } on Exception catch (exception, stackTrace) {
      this._status = PostPageStatus.error;
      log("Erro ao deletar a publicação", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> updateComment(int postId, int commentId, String content) async {
    try {
      this._status = PostPageStatus.updatingComment;

      await this._postService.updateComment(postId, commentId, content);
      final int index = this._commentsOfOpenedPost.indexWhere((comment) => comment.commentId == commentId);
      this._commentsOfOpenedPost[index].content = content;

      this._status = PostPageStatus.updatedComment;
    } on Exception catch (exception, stackTrace) {
      this._status = PostPageStatus.error;
      log("Erro ao atualizar o comentário $commentId!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> showModalWithTags() async {
    try {
      this._status = PostPageStatus.loadingAllTags;

      this._allTags.clear();
      this._allTags.addAll(await this._interestService.getAll());

      this._status = PostPageStatus.loadedAllTags;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = PostPageStatus.error;
      this._error = "Houve um erro ao buscar as tags!";
      log("Erro crítico ao buscar todos os interesses!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> savePost(String? content, String? tablature) async {
    try {
      this._status = PostPageStatus.savingPost;

      await this._postService.savePost(
        this._postId,
        content,
        tablature == "e  | " ? null : tablature,
        this._selectedTags.map((t) => t.interestId).toList(),
        this._newMedias,
        this._oldMediasToRemove
      );

      this._status = PostPageStatus.savedPost;
    } on InvalidFormException catch (exception) {
      this._status = PostPageStatus.error;
      this._error = exception.errorsConcatened;
    } on AuthenticatedUserAreNotOwnerOfPostException catch (exception) {
      this._status = PostPageStatus.error;
      this._error = exception.message;
      this._showForm = false;
    } on PostNotFoundException catch (exception) {
      this._status = PostPageStatus.error;
      this._error = exception.message;
      this._showForm = false;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = PostPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao salvar a publicação!", error: exception, stackTrace: stackTrace);
    }
  }
}