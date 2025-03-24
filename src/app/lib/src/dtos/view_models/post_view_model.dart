import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/dtos/view_models/media_view_model.dart";
import "package:sonorus/src/dtos/view_models/user_view_model.dart";

class PostViewModel {
  final int postId;
  final String? content;
  final DateTime postedAt;
  int totalLikes;
  int totalComments;
  final String? tablature;
  final UserViewModel author;
  bool isLikedByMe;
  final List<InterestDto> interests;
  final List<MediaViewModel> medias;

  PostViewModel({
    required this.postId,
    this.content,
    required this.postedAt,
    required this.totalLikes,
    required this.totalComments,
    this.tablature,
    required this.author,
    required this.isLikedByMe,
    required this.interests,
    required this.medias
  });

  factory PostViewModel.fromMap(Map<String, dynamic> map) => PostViewModel(
    postId: map["postId"] as int,
    content: map["content"],
    postedAt: DateTime.parse(map["postedAt"] as String),
    totalLikes: map["totalLikes"] as int,
    totalComments: map["totalComments"] as int,
    tablature: map["tablature"],
    author: UserViewModel.fromMap(map["author"]),
    isLikedByMe: map["isLikedByMe"] as bool,
    interests: List<InterestDto>.from(map["interests"].map((interest) => InterestDto.fromMap(interest)).toList()),
    medias: List<MediaViewModel>.from(map["medias"].map((media) => MediaViewModel.fromMap(media)).toList())
  );
}