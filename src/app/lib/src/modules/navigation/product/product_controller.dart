// ignore_for_file: library_private_types_in_public_api, prefer_final_fields
import "dart:developer";

import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/domain/enums/condition_type.dart";
import "package:sonorus/src/domain/exceptions/authenticated_user_are_not_owner_of_product_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/product_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/view_models/media_view_model.dart";
import "package:sonorus/src/dtos/view_models/product_view_model.dart";
import "package:sonorus/src/services/product/product_service.dart";

part "product_controller.g.dart";

class ProductController = _ProductControllerBase with _$ProductController;

enum ProductPageStatus {
  initial,
  loadingProducts,
  loadedProducts,
  creatingProduct,
  createdProduct,
  updatingProduct,
  updatedProduct,
  error
}

abstract class _ProductControllerBase with Store {
  final ProductService _service;

  @readonly
  ProductPageStatus _status = ProductPageStatus.initial;

  @readonly
  bool _showForm = false;

  @readonly
  int? _productId;

  @readonly
  ConditionType _conditionType = ConditionType.new_;

  @readonly
  ObservableList<ProductViewModel> _products = ObservableList();

  @readonly
  ObservableList<int> _oldMediasToRemove = ObservableList();

  @readonly
  ObservableList<XFile> _newMedias = ObservableList<XFile>();

  @readonly
  ObservableList<MediaViewModel> _oldMedias = ObservableList<MediaViewModel>();

  @readonly
  ProductViewModel? _savedProduct;

  @readonly
  String? _error;

  _ProductControllerBase(this._service);

  @action
  void toggleShowForm(bool? showForm) => this._showForm = showForm ?? !this._showForm;

  @action
  void setProductId(int? productId) => this._productId = productId;

  @action
  void setConditionType(ConditionType conditionType) => this._conditionType = conditionType;

  @action
  void addNewMedias(List<XFile> newMedias) => this._newMedias.addAll(newMedias);

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
  void removeSavedOpportunity() => this._savedProduct = null;

  @action
  Future<void> getAllWithQuery({ String? name }) async {
    try {
      this._status = ProductPageStatus.loadingProducts;

      this._products.clear();
      this._products.addAll(await this._service.getAllWithQuery(name));

      this._status = ProductPageStatus.loadedProducts;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProductPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao buscar os anúncios!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> saveProduct(String name, String? description, double price) async {
    try {
      this._status = ProductPageStatus.updatingProduct;

      this._savedProduct = await this._service.saveProduct(
        this._productId,
        name,
        price,
        description,
        this._conditionType,
        this._newMedias,
        this._oldMediasToRemove
      );

      this._status = ProductPageStatus.updatedProduct;
    } on InvalidFormException catch (exception) {
      this._status = ProductPageStatus.error;
      this._error = exception.errorsConcatened;
    } on AuthenticatedUserAreNotOwnerOfProductException catch (exception) {
      this._status = ProductPageStatus.error;
      this._error = exception.message;
      this._showForm = false;
    } on ProductNotFoundException catch (exception) {
      this._status = ProductPageStatus.error;
      this._error = exception.message;
      this._showForm = false;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProductPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao salvar o anúncio!", error: exception, stackTrace: stackTrace);
    }
  }
}