import "dart:math";

import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";

class RandomProductShimmer extends StatelessWidget {
  const RandomProductShimmer({ super.key });

  @override
  Widget build(BuildContext context) {
    final double heigth = (300 + Random().nextInt(100)).toDouble();
    final double widthNameProduct = (50 + Random().nextInt(80)).toDouble();
    final double widthPriceProduct = (20 + Random().nextInt(55)).toDouble();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF404048)
      ),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: context.colors.secondary,
            highlightColor: Colors.grey.withAlpha(75),
            child: Container(height: heigth, decoration: const BoxDecoration(color: Colors.white))
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7.5),
            height: 60,
            child: Row(
              children: [
                ClipOval(
                  child: Shimmer.fromColors(
                    baseColor: context.colors.secondary,
                    highlightColor: Colors.grey.withAlpha(75),
                    child: Container(
                      height: 45,
                      width: 45,
                      color: Colors.white
                    )
                  )
                ),
                const SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Shimmer.fromColors(
                      baseColor: context.colors.secondary,
                      highlightColor: Colors.grey.withAlpha(75),
                      child: Container(
                        width: widthNameProduct,
                        height: 15,
                        decoration: const BoxDecoration(color: Colors.white)
                      )
                    ),
                    const SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: context.colors.secondary,
                      highlightColor: Colors.grey.withAlpha(75),
                      child: Container(
                        width: widthPriceProduct,
                        height: 10,
                        decoration: const BoxDecoration(color: Colors.white)
                      )
                    )
                  ]
                )
              ]
            )
          )
        ]
      )
    );
  }
}