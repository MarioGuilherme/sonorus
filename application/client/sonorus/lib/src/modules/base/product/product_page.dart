import "package:carousel_slider/carousel_slider.dart";
import "package:convex_bottom_bar/convex_bottom_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/message_model.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/models/user_model.dart";
import "package:sonorus/src/modules/base/product/product_controller.dart";
import "package:sonorus/src/modules/base/widgets/picture_user.dart";

class ProductPage extends StatefulWidget {
  final ProductModel product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();


  @override 
  Widget build(BuildContext context) {
    final List<Widget> mediaSliders = this.widget.product.medias.map((media) => Image.network(media.path, fit: BoxFit.cover)).toList();

    return Scaffold(
      appBar: AppBar(title: Text(this.widget.product.name)),
      backgroundColor: const Color(0xFF16161F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
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
                            carouselController: this._controller,
                            options: CarouselOptions(
                              autoPlay: true,
                              height: 300,
                              viewportFraction: 1,
                              onPageChanged: (i, _) => setState(() => this._current = i)
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: this.widget.product.medias.asMap().entries.map((entry) => GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
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
                            this.widget.product.price.toString(),
                            style: context.textStyles.textSemiBold.copyWith(color: const Color.fromARGB(255, 124, 249, 128), fontSize: 16.sp)
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Condição",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                          ),
                          Text(
                            "Semi-usado",
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
                            text: this.widget.product.seller.nickname,
                            style: context.textStyles.textBold.copyWith(fontSize: 12.sp),
                            children: [
                              TextSpan(
                                text: " anunciou isso",
                                style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                              ),
                              TextSpan(
                                text: " há ${this.widget.product.timeAgo}",
                                style: context.textStyles.textBold.copyWith(fontSize: 12.sp)
                              )
                            ]
                          )
                        )
                      )
                    ]
                  ),
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
              )
            ]
          )
        )
      )
    );
  }
}