import "package:brasil_fields/brasil_fields.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/widgets/header_tab_content.dart";
import "package:sonorus/src/domain/enums/condition_type.dart";
import "package:sonorus/src/dtos/view_models/product_view_model.dart";
import "package:sonorus/src/modules/navigation/product/product_controller.dart";
import "package:sonorus/src/modules/navigation/product/widgets/product.dart";
import "package:sonorus/src/modules/navigation/product/widgets/product_form.dart";
import "package:sonorus/src/modules/navigation/product/widgets/random_product_shimmer.dart";

class ProductPage extends StatefulWidget {
  const ProductPage({ super.key });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with Messages, CustomShimmer, Loader {
  final ProductController _controller = Modular.get<ProductController>();
  final TextEditingController _nameEC = TextEditingController();
  final TextEditingController _priceEC = TextEditingController();
  final TextEditingController _descriptionEC = TextEditingController();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getAllWithQuery();
    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) {
      switch (status) {
        case ProductPageStatus.initial:
        case ProductPageStatus.loadingProducts:
        case ProductPageStatus.loadedProducts: break;
        case ProductPageStatus.updatedProduct:
        case ProductPageStatus.createdProduct:
          this.switchShowForm(showForm: false);
          this.hideLoader();
          this._controller.getAllWithQuery();
          this.showQuestionMessage(
            title: "Sucesso!",
            message: "Seu anúncio foi salvo, deseja visualizá-lo?",
            onConfirmButtonPressed: () {
              Modular.to.pop();
              Modular.to.pushNamed("/products/details/", arguments: this._controller.savedProduct).then((obj) async {
                if (obj.runtimeType != ProductViewModel) {
                  this._controller.getAllWithQuery();
                  return;
                }
                final ProductViewModel productViewModel = obj as ProductViewModel;
                this.bindForm(productViewModel);
              });
            },
            onCancelButtonPressed: () {
              Modular.to.pop();
              this._controller.removeSavedOpportunity();
            }
          );
          break;
        case ProductPageStatus.creatingProduct:
        case ProductPageStatus.updatingProduct:
          this.showLoader();
          break;
        case ProductPageStatus.error:
          this.hideLoader();
          this.showErrorMessage(this._controller.error);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._statusReactionDisposer();
    super.dispose();
  }

  void bindForm(ProductViewModel productViewModel) {
    this.switchShowForm(showForm: true);
    this._controller.setProductId(productViewModel.productId);
    this._controller.addOldMedias(productViewModel.medias);
    this._controller.setConditionType(productViewModel.condition);
    this._priceEC.text = UtilBrasilFields.obterReal(productViewModel.price);
    this._nameEC.text = productViewModel.name;
    this._descriptionEC.text = productViewModel.description ?? "";
  }

  void clearForm() {
    this._controller.setProductId(null);
    this._controller.setConditionType(ConditionType.new_);
    this._controller.newMedias.clear();
    this._controller.oldMediasToRemove.clear();
    this._controller.oldMedias.clear();
    this._nameEC.clear();
    this._descriptionEC.clear();
    this._priceEC.clear();
  }

  void switchShowForm({ bool? showForm }) {
    this.clearForm();
    this._controller.toggleShowForm(showForm);
  }

  @override 
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      final SingleChildScrollView child = SingleChildScrollView(
        child: Column(
          children: [
            Observer(
              builder: (context) => HeaderTabContent(
                entityName: "ANÚNCIO",
                showForm: this._controller.showForm,
                isEdit: this._controller.productId != null,
                onCallDebouncer: this._controller.getAllWithQuery,
                onUpdatedShowForm: () {
                  this.clearForm();
                  this._controller.toggleShowForm(null);
                }
              )
            ),
            const SizedBox(height: 12),
            Observer(
              builder: (_) {
                if (this._controller.showForm)
                  return ProductForm(
                    nameEC: this._nameEC,
                    priceEC: this._priceEC,
                    descriptionEC: this._descriptionEC,
                    conditionType: this._controller.conditionType,
                    setConditionType: this._controller.setConditionType,
                    newMedias: [...this._controller.newMedias],
                    oldMedias: [...this._controller.oldMedias],
                    addNewMedias: this._controller.addNewMedias,
                    removeNewMedia: this._controller.removeNewMedia,
                    removeOldMedia: this._controller.removeOldMedia,
                    onSubmitValid: () async {
                      if ([this._controller.newMedias, this._controller.oldMedias].isEmpty) {
                        this.showErrorMessage("É necessário ter em anexo no mínimo uma foto ou vídeo!");
                        return;
                      }
                      await this._controller.saveProduct(
                        this._nameEC.text,
                        this._descriptionEC.text,
                        UtilBrasilFields.converterMoedaParaDouble(this._priceEC.text)
                      );
                    }
                  );
      
                if (this._controller.status == ProductPageStatus.loadingProducts)
                  return StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    children: this.createRandomShimmers(() => const RandomProductShimmer())
                  );
      
                if (this._controller.products.isEmpty)
                  return Center(
                    child: Text(
                      "Nenhum anúncio encontrado",
                      textAlign: TextAlign.center,
                      style: context.textStyles.textMedium.withFontSize(14),
                    )
                  );
      
                return StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: this._controller.products.map((product) => StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: Product(productViewModel: product, onPopPage: (productViewModel) async {
                      if (productViewModel == null) {
                        this._controller.getAllWithQuery();
                        return;
                      }
                      this.bindForm(productViewModel);
                    })
                  )).toList()
                );
              }
            )
          ]
        )
      );
      return this._controller.showForm
        ? RefreshIndicator.noSpinner(child: child, onRefresh: () async {})
        : RefreshIndicator(onRefresh: this._controller.getAllWithQuery, child: child);
    }
  );
}