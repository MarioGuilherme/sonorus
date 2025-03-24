import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/extensions/currency_extension.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/dtos/view_models/product_view_model.dart";
import "package:sonorus/src/modules/navigation/post/widgets/video_media_post.dart";
import "package:sonorus/src/modules/navigation/widgets/picture_user.dart";

class Product extends StatelessWidget {
  final ProductViewModel productViewModel;
  final Future<void> Function(ProductViewModel?) onPopPage;

  const Product({
    required this.onPopPage,
    required this.productViewModel,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          !this.productViewModel.medias.first.isPicture
            ? SizedBox(height: 300, child: VideoMediaPost(this.productViewModel.medias.first.path))
            : Image.network(
                this.productViewModel.medias.first.path,
                loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                  ? child
                  : SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null
                        )
                      )
                    )
              ),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7.5),
            decoration: const BoxDecoration(color: Color.fromRGBO(55, 55, 57, .8), borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            child: Row(
              children: [
                PictureUser(picture: Image.network(this.productViewModel.seller.picture, width: 45, height: 45, fit: BoxFit.cover)),
                const SizedBox(width: 5),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        this.productViewModel.name,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.textSemiBold.withFontSize(12)
                      ),
                      Text(
                        this.productViewModel.price.currency,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.textRegular.copyWith(color: const Color.fromARGB(255, 124, 249, 128), fontSize: 11.sp)
                      )
                    ]
                  )
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
                onTap: () => Modular.to.pushNamed(
                  "/products/details/",
                  arguments: this.productViewModel
                ).then((productViewModel) async => this.onPopPage(productViewModel as ProductViewModel?))
              )
            )
          )
        ]
      )
    );
  }
}