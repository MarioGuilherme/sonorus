import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";

class UpdatePostInputModel {
  final String? content;
  final String? tablature;
  final List<int> interestsIds;
  final List<XFile> newMedias;
  final List<int> mediasToRemove;

  UpdatePostInputModel({
    this.content,
    this.tablature,
    required this.interestsIds,
    required this.mediasToRemove,
    required this.newMedias
  });

  FormData toFormData() {
    final FormData formData = FormData.fromMap({
      "content": this.content,
      "tablature": this.tablature,
      "interestsIds": this.interestsIds,
      "mediasToRemove": this.mediasToRemove
    });
    formData.files.addAll(this.newMedias.map((media) => MapEntry("newMedias", MultipartFile.fromFileSync(media.path))));
    return formData;
  }
}