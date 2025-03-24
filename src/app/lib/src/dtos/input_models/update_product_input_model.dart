import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";

import "package:sonorus/src/domain/enums/condition_type.dart";

class UpdateProductInputModel {
  final String name;
  final double price;
  final String? description;
  final ConditionType condition;
  final List<XFile> newMedias;
  final List<int> mediasToRemove;

  UpdateProductInputModel({
    required this.name,
    required this.price,
    this.description,
    required this.condition,
    required this.newMedias,
    required this.mediasToRemove
  });

  FormData toFormData() {
    final FormData formData = FormData.fromMap({
      "name": this.name,
      "price": this.price.toString().replaceAll(".", ","),
      "description": this.description,
      "condition": this.condition.id,
      "mediasToRemove": mediasToRemove
    });
    formData.files.addAll(newMedias.map((media) => MapEntry("newMedias", MultipartFile.fromFileSync(media.path))));
    return formData;
  }
}