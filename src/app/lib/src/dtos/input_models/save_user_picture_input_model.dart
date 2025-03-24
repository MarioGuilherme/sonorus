import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";

class UpdateUserPictureInputModel {
  final XFile file;

  UpdateUserPictureInputModel({ required this.file });

  FormData toFormData() => FormData.fromMap({ "file": MultipartFile.fromFileSync(file.path) });
}