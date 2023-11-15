import "dart:io";

import "package:brasil_fields/brasil_fields.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:image_picker/image_picker.dart";
import "package:sonorus/src/core/extensions/time_ago_extension.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/utils/routes.dart";
import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/condition_type.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/modules/base/creation/creation_controller.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_controller.dart";
import "package:sonorus/src/modules/base/timeline/widgets/video_media_post.dart";
import "package:sonorus/src/modules/base/widgets/picture_user.dart";
import "package:validatorless/validatorless.dart";

class ProductPage extends StatefulWidget {
  final ProductModel product;

  const ProductPage({ super.key, required this.product });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with Messages, Loader {
  int _current = 0;
  final CarouselController _controllerCarousel = CarouselController();
  final MarketplaceController _marketplaceController = Modular.get<MarketplaceController>();
  final CreationController _creationController = Modular.get<CreationController>();

  final TextEditingController _productNameEC = TextEditingController();
  final TextEditingController _productDescriptionEC = TextEditingController();
  final TextEditingController _productPriceEC = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  @override 
  Widget build(BuildContext context) {
    final List<Widget> mediaSliders = this.widget.product.medias.map(
      (media) => media.path.split(".")[5] == "mp4"
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
    final int myUserId = Modular.get<CurrentUserModel>().userId!;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.product.name),
        actions: [
          myUserId == this.widget.product.seller.userId
            ? IconButton(
              onPressed: () {
                showDialog(
                  context: this.context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    actionsAlignment: MainAxisAlignment.center,
                    content: Text("O que deseja fazer com este anúncio?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                    actions: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Modular.to.pop();
                              showDialog(
                                context: this.context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  title: Text("Tem certeza?", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                  content: Text("Ao definir este anúncio como vendido, ele será removido do marketplace, deseja prosseguir?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Modular.to.pop();
                                            this.showLoader();
                                            this._marketplaceController.deleteProductById(this.widget.product.productId).then((_) {
                                              this.hideLoader();
                                              showDialog(
                                                context: this.context,
                                                builder: (context) => AlertDialog(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                  title: Text("Sucesso", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                                  content: Text("Anúncio vendido e removido com sucesso", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                                  actionsAlignment: MainAxisAlignment.center,
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20))
                                                      ),
                                                      onPressed: () => Modular.to.popUntil(ModalRoute.withName(Routes.marketplacePage)),
                                                      child: Text("OK", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                                                    )
                                                  ]
                                                )
                                              );
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(10)
                                          ),
                                          label: const Text("Sim"),
                                          icon: const Icon(Icons.check)
                                        ),
                                        const SizedBox(width: 10,),
                                        ElevatedButton.icon(
                                          onPressed: Modular.to.pop,
                                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                                          label: const Text("Não"),
                                          icon: const Icon(Icons.cancel)
                                        )
                                      ]
                                    )
                                  ]
                                )
                              );
                            },
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                            label: const Text("Marcar como vendido"),
                            icon: const Icon(Icons.delete)
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton.icon(
                            onPressed: () {
                              this._creationController.clearOldMedias();
                              this._creationController.clearnewMedias();
                              this._creationController.setoldMMedias(this.widget.product.medias.map((media) => XFile(media.path)).toList());
                              this._creationController.toggleConditionProduct(this.widget.product.condition);
                              this._productDescriptionEC.text = this.widget.product.description ?? "";
                              this._productNameEC.text = this.widget.product.name;
                              this._productPriceEC.text = UtilBrasilFields.obterReal(this.widget.product.price);
                              showDialog(
                                context: this.context,
                                builder: (context) => Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    color: context.colors.secondary,
                                    child: Observer(
                                      builder: (context) {
                                        return Form(
                                          key: this._formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              SizedBox(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    Modular.to.pop();
                                                  },
                                                  child: const Icon(Icons.close)
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Editando anúncio",
                                                      textAlign: TextAlign.center,
                                                      style: context.textStyles.textBold.copyWith(fontSize: 22.sp)
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextFormField(
                                                      textInputAction: TextInputAction.next,
                                                      controller: this._productNameEC,
                                                      style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                      validator: Validatorless.multiple([
                                                        Validatorless.required("O nome do produto é obrigatório."),
                                                        Validatorless.max(50, "O nome pode ter no máximo 50 caracteres.")
                                                      ]),
                                                      decoration: InputDecoration(
                                                        label: Text("Nome do produto", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                                        prefixIcon: const Icon(Icons.inventory_2, color: Colors.white, size: 24),
                                                        isDense: true
                                                      )
                                                    ),
                                                    const SizedBox(height: 20),
                                                    TextFormField(
                                                      textInputAction: TextInputAction.newline,
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: null,
                                                      minLines: 5,
                                                      controller: this._productDescriptionEC,
                                                      style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                      validator: Validatorless.max(255, "A descrição do produto pode ter no máximo 255 caracteres."),
                                                      decoration: InputDecoration(
                                                        label: Text("Descrição", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                                        prefixIcon: const Icon(Icons.description, color: Colors.white, size: 24),
                                                        isDense: true
                                                      )
                                                    ),
                                                    const SizedBox(height: 20),
                                                    TextFormField(
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                        CentavosInputFormatter(moeda: true),
                                                      ],
                                                      keyboardType: TextInputType.number,
                                                      textInputAction: TextInputAction.next,
                                                      controller: this._productPriceEC,
                                                      style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                      validator: Validatorless.required("O preço do produto é obrigatório."),
                                                      decoration: InputDecoration(
                                                        label: Text("Preço", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                                        prefixIcon: const Icon(Icons.attach_money, color: Colors.white, size: 24),
                                                        isDense: true
                                                      )
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Condição",
                                                          style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                                                        ),
                                                        const SizedBox(width: 30),
                                                        DropdownButton<ConditionType>(
                                                          icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                                                          isDense: true,
                                                          value: this._creationController.conditionType,
                                                          style: context.textStyles.textMedium.copyWith(fontSize: 14.sp, color: context.colors.primary),
                                                          underline: Container(),
                                                          onChanged: (value) {
                                                            this._creationController.toggleConditionProduct(value!);
                                                          },
                                                          items: const [
                                                            DropdownMenuItem<ConditionType>(
                                                              value: ConditionType.new_,
                                                              child: Text("Novo")
                                                            ),
                                                            DropdownMenuItem<ConditionType>(
                                                              value: ConditionType.semiUsed,
                                                              child: Text("Semi-Usado")
                                                            ),
                                                            DropdownMenuItem<ConditionType>(
                                                              value: ConditionType.used,
                                                              child: Text("Usado")
                                                            )
                                                          ]
                                                        )
                                                      ]
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Text(
                                                      "Mídias",
                                                      style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                                                    ),
                                                    (this._creationController.oldmedias.length + this._creationController.newMedias.length == 0)
                                                      ? Container(
                                                        height: 129,
                                                        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                                        child: Center(
                                                          child: Text(
                                                            "Suas mídias aparecerão aqui",
                                                            style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                                          )
                                                        )
                                                      )
                                                      : Expanded(
                                                        child: SingleChildScrollView(
                                                          child: GridView(
                                                              shrinkWrap: true,
                                                              physics: const NeverScrollableScrollPhysics(),
                                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 3,
                                                                mainAxisSpacing: 10
                                                              ),
                                                              children: [...this._creationController.oldmedias, ...this._creationController.newMedias].map(
                                                                (media) => Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    media.path.split(".")[5] == "mp4"
                                                                      ? Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 3),
                                                                        child: VideoMediaPost(media.path),
                                                                      )
                                                                      : media.path[0] == "/"
                                                                        ? Image.file(
                                                                            File(media.path),
                                                                            fit: BoxFit.contain,
                                                                          )
                                                                        : Image.network(
                                                                            media.path,
                                                                            fit: BoxFit.contain,
                                                                          ),
                                                                    Align(
                                                                      alignment: Alignment.topRight,
                                                                      child: IconButton(
                                                                        splashRadius: 1,
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            this._creationController.removeFrom2list(media);
                                                                          });
                                                                        },
                                                                        icon: ClipOval(
                                                                          child: Container(
                                                                            color: context.colors.primary,
                                                                            child: const Center(child: Icon(Icons.delete))
                                                                          )
                                                                        )
                                                                      )
                                                                    )
                                                                  ]
                                                                )
                                                              ).toList()
                                                            ),
                                                        ),
                                                      ),
                                                    if (this._creationController.oldmedias.length + this._creationController.newMedias.length < 5) ...[
                                                      const SizedBox(height: 10),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          this._picker.pickMultipleMedia().then((medias) {
                                                            if (this._creationController.oldmedias.length + this._creationController.newMedias.length + medias.length > 5)
                                                              this._creationController.addNewMedias(medias.sublist(0, (5 - (this._creationController.oldmedias.length + this._creationController.newMedias.length))));
                                                            else
                                                              this._creationController.addNewMedias(medias);
                                                          });
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                                          child: Text("Anexar fotos ou vídeos"),
                                                        )
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        "No máximo 5 mídias",
                                                        textAlign: TextAlign.center,
                                                        style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                                      )
                                                    ]
                                                  ],
                                                )
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey),
                                                onPressed: () async {
                                                  final bool formValid = this._formKey.currentState?.validate() ?? false;
                                
                                                  if (formValid) {
                                                    showLoader();
                                                    await this._creationController.updateProduct(
                                                      this.widget.product.productId,
                                                      this._productNameEC.text,
                                                      this._creationController.conditionType!,
                                                      this._productDescriptionEC.text,
                                                      UtilBrasilFields.converterMoedaParaDouble(this._productPriceEC.text),
                                                      [...this._creationController.oldmedias, ...this._creationController.newMedias].map((media) => XFile(media.path)).toList()
                                                    ).then((_) {
                                                      hideLoader();
                                                      showDialog(
                                                        barrierDismissible: true,
                                                        context: this.context,
                                                        builder: (context) => AlertDialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                          title: Text("Sucesso", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                                          content: Text("Anúncio atualizado com sucesso", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                                          actionsAlignment: MainAxisAlignment.center,
                                                          actions: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20))
                                                              ),
                                                              onPressed: () {
                                                                Modular.to.pop();
                                                                Modular.to.pop();
                                                                Modular.to.pop();
                                                                Modular.to.pop();
                                                                this._marketplaceController.getAllProducts();
                                                              },
                                                              child: Text("Ok", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                                                            )
                                                          ]
                                                        )
                                                      );
                                                    });
                                                  }
                                                },
                                                child: const Text("Atualizar")
                                              )
                                            ]
                                          )
                                        );
                                      }
                                    )
                                  )
                                )
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10)
                            ),
                            label: const Text("Editar"),
                            icon: const Icon(Icons.edit)
                          )
                        ]
                      )
                    ]
                  )
                );
              },
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 28
              )
            )
          : const SizedBox.shrink()
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
                          CarouselSlider(
                            items: mediaSliders,
                            carouselController: this._controllerCarousel,
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              height: 300,
                              viewportFraction: 1,
                              onPageChanged: (i, _) => setState(() => this._current = i)
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: this.widget.product.medias.asMap().entries.map((entry) => GestureDetector(
                              onTap: () => _controllerCarousel.animateToPage(entry.key),
                              child: Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colors.primary.withOpacity(_current == entry.key ? 0.9 : 0.4)
                                )
                              )
                            )).toList()
                          )
                        ]
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            this.widget.product.name,
                            style: context.textStyles.textExtraBold.copyWith(fontSize: 22.sp)
                          ),
                          Text(
                            this.widget.product.formatedCurrency,
                            style: context.textStyles.textSemiBold.copyWith(color: const Color.fromARGB(255, 124, 249, 128), fontSize: 16.sp)
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Condição",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                          ),
                          Text(
                            this.widget.product.conditionString,
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Descrição",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                          ),
                          Text(
                            this.widget.product.description ?? "Nenhuma descrição",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
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
                      PictureUser(
                        picture: Image.network(
                          this.widget.product.seller.picture,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover
                        )
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: myUserId == this.widget.product.seller.userId
                                  ? "Você"
                                  : this.widget.product.seller.nickname,
                            style: context.textStyles.textBold.copyWith(fontSize: 12.sp),
                            children: [
                              TextSpan(
                                text: " anunciou isso",
                                style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                              ),
                              TextSpan(
                                text: " há ${this.widget.product.announcedAt.timeAgo}",
                                style: context.textStyles.textBold.copyWith(fontSize: 12.sp)
                              )
                            ]
                          )
                        )
                      )
                    ]
                  ),
                  if (this.widget.product.seller.userId != myUserId) ...[
                    const SizedBox(height: 5),
                    ElevatedButton.icon(
                      onPressed: () => Modular.to.popAndPushNamed(
                        "/chat/",
                        arguments: [
                          "Olá, tenho interesse neste seu produto \"${this.widget.product.name}\", ainda está disponível?",
                          ChatModel(
                            friend: this.widget.product.seller,
                            messages: []
                          )
                        ]
                      ),
                      icon: const Icon(Icons.paid),
                      label: const Text("Tenho interesse")
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