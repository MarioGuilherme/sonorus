import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";

class CreatePostInputModel {
  final String? content;
  final String? tablature;
  final List<XFile> medias;
  final List<int> interestsIds;

  CreatePostInputModel({
    this.content,
    this.tablature,
    required this.medias,
    required this.interestsIds
  });
  
  FormData toFormData() {
    final FormData formData = FormData.fromMap({
      "content": this.content,
      "tablature": this.tablature,
      "interestsIds": this.interestsIds
    });
    formData.files.addAll(this.medias.map((media) => MapEntry("medias", MultipartFile.fromFileSync(media.path))));
    return formData;
  }
}