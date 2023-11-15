import "package:image_picker/image_picker.dart";

class PostRegisterModel {
  final int? postId;
  final String? content;
  final String? tablature;
  final List<int> interestsIds;
  final List<XFile> medias;

  PostRegisterModel({
    this.postId,
    this.content,
    this.tablature,
    required this.interestsIds,
    required this.medias
  });
}