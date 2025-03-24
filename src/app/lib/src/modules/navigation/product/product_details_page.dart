import "package:carousel_slider/carousel_slider.dart" as carousel_slider;
import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/extensions/condition_type_extension.dart";
import "package:sonorus/src/core/extensions/currency_extension.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/extensions/time_ago_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/view_models/product_view_model.dart";
import "package:sonorus/src/modules/navigation/post/widgets/video_media_post.dart";
import "package:sonorus/src/modules/navigation/product/product_details_controller.dart";
import "package:sonorus/src/modules/navigation/widgets/picture_user.dart";

class ProductDetailsPage extends StatefulWidget {
  final ProductViewModel productViewModel;

  const ProductDetailsPage({ super.key, required this.productViewModel });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> with Messages, Loader {
  final carousel_slider.CarouselSliderController _controllerCarousel = carousel_slider.CarouselSliderController();
  final ProductDetailsController _controller = Modular.get<ProductDetailsController>();
  late final ReactionDisposer _statusReactionDisposer;
  int _current = 0;

  @override
  void initState() {
    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) {
      switch (status) {
        case ProductDetailsPageStatus.initial:
        case ProductDetailsPageStatus.deletingProduct:
          Modular.to.pop();
          this.showLoader();
          break;
        case ProductDetailsPageStatus.deletedProduct:
          this.hideLoader();
          this.showSuccessMessage("Anúncio vendido e removido com sucesso!", onConfirm: () => Modular.to.popUntil(ModalRoute.withName("/products/")));
          break;
        case ProductDetailsPageStatus.error:
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

  @override 
  Widget build(BuildContext context) {
    final List<Widget> mediaSliders = this.widget.productViewModel.medias.map((media) => !media.isPicture
      ? VideoMediaPost(media.path)
      : Image.network(
          media.path,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null
                )
              )
            );
          }
        )
    ).toList();
    final int myUserId = Modular.get<AuthenticatedUser>().userId!;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.productViewModel.name, style: context.textStyles.textMedium),
        actions: [
          myUserId != this.widget.productViewModel.seller.userId
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.more_horiz, size: 28),
                onPressed: () {
                  this.showMessageWithActions(
                    title: "Opções do anúncio",
                    message: "O que deseja fazer com este anúncio?",
                    actions: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                        label: const Text("Marcar como vendido"),
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Modular.to.pop();
                          this.showQuestionMessage(
                            title: "Tem certeza?",
                            message: "Ao definir este anúncio como vendido, ele será removido do marketplace, deseja prosseguir?", 
                            onConfirmButtonPressed: () async => this._controller.deleteProductById(this.widget.productViewModel.productId)
                          );
                        }
                      ),
                      const SizedBox(height: 10,),
                      ElevatedButton.icon(
                        onPressed: () {
                          Modular.to.pop();
                          Modular.to.pop(this.widget.productViewModel);
                        },
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                        label: const Text("Editar"),
                        icon: const Icon(Icons.edit)
                      )
                    ]
                  );
                }
              )
        ]
      ),
      backgroundColor: const Color(0xFF16161F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                         carousel_slider.CarouselSlider(
                            items: mediaSliders,
                            carouselController: this._controllerCarousel,
                            options: carousel_slider.CarouselOptions(
                              enableInfiniteScroll: false,
                              height: 300,
                              viewportFraction: 1,
                              onPageChanged: (i, _) => setState(() => this._current = i)
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: this.widget.productViewModel.medias.asMap().entries.map((entry) => GestureDetector(
                              onTap: () => _controllerCarousel.animateToPage(entry.key),
                              child: Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colors.primary.withValues(alpha: this._current == entry.key ? 0.9 : 0.4)
                                )
                              )
                            )).toList()
                          )
                        ]
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(this.widget.productViewModel.name, style: context.textStyles.textExtraBold.withFontSize(22)),
                          Text(this.widget.productViewModel.price.currency, style: context.textStyles.textSemiBold.copyWith(color: const Color.fromARGB(255, 124, 249, 128), fontSize: 16.sp)),
                          const SizedBox(height: 10),
                          Text("Condição", textAlign: TextAlign.justify, style: context.textStyles.textBold.withFontSize(16)),
                          Text(this.widget.productViewModel.condition.text, textAlign: TextAlign.justify, style: context.textStyles.textRegular.withFontSize(12)),
                          const SizedBox(height: 10),
                          Text("Descrição", textAlign: TextAlign.justify, style: context.textStyles.textBold.withFontSize(16)),
                          Text(
                            this.widget.productViewModel.description ?? "Nenhuma descrição",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textRegular.withFontSize(12)
                          )
                        ]
                      )
                    ]
                  )
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(color: Colors.white),
                  Row(
                    children: [
                      PictureUser(picture: Image.network(this.widget.productViewModel.seller.picture, width: 50, height: 50, fit: BoxFit.cover)),
                      const SizedBox(width: 10),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: myUserId == this.widget.productViewModel.seller.userId ? "Você" : this.widget.productViewModel.seller.nickname,
                            style: context.textStyles.textBold.withFontSize(12),
                            children: [
                              TextSpan(text: " anunciou isso", style: context.textStyles.textRegular.withFontSize(12)),
                              TextSpan(text: " há ${this.widget.productViewModel.announcedAt.timeAgo}", style: context.textStyles.textBold.withFontSize(12))
                            ]
                          )
                        )
                      )
                    ]
                  ),
                  if (this.widget.productViewModel.seller.userId != myUserId) ...[
                    const SizedBox(height: 5),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.paid),
                      label: const Text("Tenho interesse"),
                      onPressed: () => Modular.to.popAndPushNamed("/chat/",
                        arguments: [
                          this.widget.productViewModel.seller,
                          "Olá, tenho interesse neste seu produto \"${this.widget.productViewModel.name}\", ainda está disponível?",
                        ]
                      )
                    )
                  ]
                ]
              )
            ]
          )
        )
      )
    );
  }
}