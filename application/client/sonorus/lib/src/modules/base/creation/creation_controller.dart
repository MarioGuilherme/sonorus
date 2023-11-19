import "dart:developer";

import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/models/condition_type.dart";
import "package:sonorus/src/models/creation_type_enum.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/interest_type.dart";
import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/models/opportunity_model_register.dart";
import "package:sonorus/src/models/post_register_model.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/models/product_register_model.dart";
import "package:sonorus/src/models/work_time_unit.dart";
import "package:sonorus/src/services/creation/creation_service.dart";

part "creation_controller.g.dart";

class CreationController = _CreationControllerBase with _$CreationController;

enum CreationStateStatus {
  initial,
  creatingOpportunity,
  creatingPost,
  creatingProduct,
  createdPost,
  createdOpportunity,
  createdProduct,
  error
}

abstract class _CreationControllerBase with Store {
  final CreationService _creationService;

  @readonly
  CreationStateStatus _creationStatus = CreationStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  CreationType? _creationType;

  @readonly
  ConditionType? _conditionType;

  @readonly
  WorkTimeUnit _workTimeUnit = WorkTimeUnit.perShow;

  @readonly
  ProductModel? _lastProductCreated;

  @readonly
  OpportunityModel? _lastOpportunityCreated;

  @readonly
  // ignore: prefer_final_fields
  ObservableList<XFile> _productMedia = ObservableList<XFile>();

  @readonly
  // ignore: prefer_final_fields
  ObservableList<XFile> _postMedia = ObservableList<XFile>();

  @readonly
  // ignore: prefer_final_fields
  ObservableList<XFile> _oldmedias = ObservableList<XFile>();

  @readonly
  // ignore: prefer_final_fields
  ObservableList<XFile> _postOldmedias = ObservableList<XFile>();

  @readonly
  // ignore: prefer_final_fields
  ObservableList<XFile> _newMedias = ObservableList<XFile>();

  @readonly
  // ignore: prefer_final_fields
  ObservableList<XFile> _postnewmedias = ObservableList<XFile>();

  @readonly
  // ignore: prefer_final_fields
  ObservableList<InterestModel> _allTags = ObservableList<InterestModel>();

  @readonly
  // ignore: prefer_final_fields
  ObservableList<InterestModel> _tagsSelectedToPost = ObservableList<InterestModel>();

  _CreationControllerBase(this._creationService);

  @action
  void toggleTagToPost(InterestModel interestPressed) {
    if (this.tagIsSelected(interestPressed.interestId!)) {
      this._tagsSelectedToPost.remove(interestPressed);
    } else {
      this._tagsSelectedToPost.add(interestPressed);
    }
  }

  @action
  void removeTagSelected(InterestModel interest) {
    this._tagsSelectedToPost.remove(interest);
  }

  @action
  void addTagSelected(InterestModel interest) {
    this._tagsSelectedToPost.add(interest);
  }

  @action
  bool tagIsSelected(int interestId) {
    return this._tagsSelectedToPost.any((i) => i.interestId == interestId);
  }

  @action
  Future<void> getAllInterests() async {
    this._allTags.clear();
    this._allTags.addAll(await this._creationService.getInterests());
  }

  @action
  Future<void> setOldTags(List<InterestModel> interests) async {
    this._tagsSelectedToPost.clear();
    this._tagsSelectedToPost.addAll(interests);
  }

  @action
  void toggleTypeCreation(CreationType? creationType) {
    this._allTags.addAll([
      InterestModel(key: "key", value: "value", type: InterestType.instrument)
    ]);
    this._creationType = creationType;
  }

  @action
  void clearLastProductRegistered() {
    this._lastProductCreated = null;
  }

  @action
  void clearLastOpportunityRegistered() {
    this._lastOpportunityCreated = null;
  }

  @action
  void toggleWorkTimeUnit(WorkTimeUnit workTimeUnit) {
    this._workTimeUnit = workTimeUnit;
  }

  @action
  void toggleConditionProduct(ConditionType conditionType) {
    this._conditionType = conditionType;
  }

  @action
  Future<void> createPost(String? content, String? tablature, List<int> interestsIds, List<XFile> medias) async {
    try {
      this._creationStatus = CreationStateStatus.creatingPost;
      final PostRegisterModel newPost = PostRegisterModel(
        content: content,
        tablature: tablature,
        interestsIds: interestsIds,
        medias: medias
      );
      await this._creationService.createPost(newPost);
      this._creationStatus = CreationStateStatus.createdPost;
    } on Exception catch (exception, stackTrace) {
      this._creationStatus = CreationStateStatus.error;
      log("Erro ao criar anúncio", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  void clearProductMedias() {
    this._productMedia.clear();
  }

  @action
  void clearPostMedias() {
    this._postOldmedias.clear();
  }

  @action
  void clearOldMedias() {
    this._oldmedias.clear();
  }

  @action
  void clearPostOldMedias() {
    this._postOldmedias.clear();
  }

  @action
  void clearnewMedias() {
    this._newMedias.clear();
  }

  @action
  void clearPostnewMedias() {
    this._postnewmedias.clear();
  }

  @action
  void clearSelectedTags() {
    this._tagsSelectedToPost.clear();
  }

  @action
  Future<void> createProduct(String name, String description, double price) async {
    try {
      this._creationStatus = CreationStateStatus.creatingProduct;
      final ProductRegisterModel productRegister = ProductRegisterModel(
        name: name,
        description: description,
        price: price,
        condition: this._conditionType ?? ConditionType.new_
      );
      this._lastProductCreated = await this._creationService.createProduct(productRegister, this._productMedia);
      this._creationStatus = CreationStateStatus.createdProduct;
    } on Exception catch (exception, stackTrace) {
      this._creationStatus = CreationStateStatus.error;
      log("Erro ao criar anúncio", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> updateProduct(int productId, String name, ConditionType condition, String description, double price, List<XFile> medias) async {

      final ProductRegisterModel productRegister = ProductRegisterModel(
        productId: productId,
        name: name.trim(),
        description: description.trim(),
        price: price,
        condition: condition,
        medias: medias
        );
      await this._creationService.updateProduct(productRegister, medias);
  }

  @action
  Future<void> updatePost(int postId, String? content, String? tablature, List<int> interestsIds, List<XFile> medias) async {
    try {
      this._creationStatus = CreationStateStatus.creatingProduct;
      final PostRegisterModel postRegister = PostRegisterModel(
        postId: postId,
        content: content!.isEmpty ? null : content.trim(),
        tablature: tablature!.isEmpty ? null : tablature.trim(),
        interestsIds: interestsIds,
        medias: medias
      );
      await this._creationService.updatePost(postRegister, medias);
      this._creationStatus = CreationStateStatus.createdProduct;
    } on Exception catch (exception, stackTrace) {
      this._creationStatus = CreationStateStatus.error;
      log("Erro ao criar publicação", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> createOpportunity(String name, String description, String? bandName, String experience, double? payment, bool isToBand) async {
    try {
      this._creationStatus = CreationStateStatus.creatingOpportunity;
      final OpportunityRegisterModel opportunity = OpportunityRegisterModel(
        experienceRequired: experience.trim(),
        isWork: !isToBand,
        name: name.trim(),
        bandName: bandName?.trim(),
        description: description.trim(),
        payment: payment,
        workTimeUnit: this._workTimeUnit
      );
      this._lastOpportunityCreated = await this._creationService.createOpportunity(opportunity);
      this._creationStatus = CreationStateStatus.createdOpportunity;
    } on Exception catch (exception, stackTrace) {
      this._creationStatus = CreationStateStatus.error;
      log("Erro ao criar anúncio", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  void setMedias(List<XFile> medias) => this._productMedia.addAll(medias);

  @action
  void setMediasPost(List<XFile> medias) => this._postMedia.addAll(medias);

  @action
  void setoldMMedias(List<XFile> medias) {
    this._oldmedias.addAll(medias);
  }

  @action
  void setPostldMMedias(List<XFile> medias) {
    this._postOldmedias.addAll(medias);
  }

  @action
  void removeMedia(XFile mediaToRemove) => this._productMedia.removeWhere((media) => media == mediaToRemove);
  
  @action
  void removeMediaPost(XFile mediaToRemove) => this._postMedia.removeWhere((media) => media == mediaToRemove);

  @action
  void removeFrom2list(XFile mediaToRemove) {
    this._oldmedias.removeWhere((media) => media == mediaToRemove);
    this._newMedias.removeWhere((media) => media == mediaToRemove);
    this._postOldmedias.removeWhere((media) => media == mediaToRemove);
    this._postnewmedias.removeWhere((media) => media == mediaToRemove);
  }
  @action
  void addNewMedias(List<XFile> mediasToAdd) {
    this._newMedias.addAll(mediasToAdd);
  }

  @action
  void addNewPostMedias(List<XFile> mediasToAdd) {
    this._postnewmedias.addAll(mediasToAdd);
  }
}