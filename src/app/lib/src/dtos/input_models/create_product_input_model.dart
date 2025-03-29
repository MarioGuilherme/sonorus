import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";

import "package:sonorus/src/domain/enums/condition_type.dart";

class CreateProductInputModel {
  final String name;
  final double price;
  final String? description;
  final ConditionType condition;
  final List<XFile> medias;

  CreateProductInputModel({
    required this.name,
    required this.price,
    this.description,
    required this.condition,
    required this.medias
  });

  FormData toFormData() {
    final FormData formData = FormData.fromMap({
      "name": this.name,
      "price": this.price,
      "description": this.description,
      "condition": this.condition.id
    });
    formData.files.addAll(medias.map((media) => MapEntry("medias", MultipartFile.fromFileSync(media.path))));
    return formData;
  }
}