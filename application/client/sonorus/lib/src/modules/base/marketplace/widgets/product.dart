import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/modules/base/widgets/picture_user.dart";

class Product extends StatelessWidget {
  final ProductModel product;

  const Product({ super.key, required this.product });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.network(this.product.medias.first.path),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7.5),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(55, 55, 57, .8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            ),
            child: Row(
              children: [
                PictureUser(
                  picture: Image.network(
                    this.product.seller.picture,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover
                  )
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      this.product.name,
                      style: context.textStyles.textSemiBold.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp
                      )
                    ),
                    Text(
                      this.product.price.toString(),
                      style: context.textStyles.textRegular.copyWith(
                        color: const Color.fromARGB(255, 124, 249, 128),
                        fontSize: 10.sp
                      )
                    )
                  ]
                )
              ]
            )
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                splashColor: context.colors.primary.withAlpha(95),
                onTap: () => Modular.to.pushNamed("/marketplace/product", arguments: this.product)
              )
            )
          )
        ]
      )
    );
  }
}