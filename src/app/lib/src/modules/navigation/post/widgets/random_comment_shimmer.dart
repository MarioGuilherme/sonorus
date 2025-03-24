import "dart:math";

import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

import "package:sonorus/src/core/extensions/size_extensions.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";

class RandomCommentShimmer extends StatelessWidget {
   const RandomCommentShimmer({ super.key });

  @override
  Widget build(BuildContext context) {
    final double sizeOfNameAuthor = (1 + Random().nextInt(context.percentWidth(.2).toInt() + context.percentWidth(.4).toInt())).toDouble();
    final double sizeOfComment = (1 + Random().nextInt(context.percentWidth(.2).toInt() + context.percentWidth(.4).toInt())).toDouble();

    return Shimmer.fromColors(
      baseColor: context.colors.secondary,
      highlightColor: Colors.grey.withAlpha(75),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(200), border: Border.all(color: context.colors.primary, width: 2)),
            child: ClipOval(child: Container(height: 50, width: 50, color: Colors.white))
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: sizeOfNameAuthor,
                    height: 15,
                    decoration: const BoxDecoration(color: Colors.white)
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: sizeOfComment,
                    height: 15,
                    decoration: const BoxDecoration(color: Colors.white)
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: context.percentWidth(.15),
                    height: 12,
                    decoration: const BoxDecoration(color: Colors.white)
                  )
                ]
              )
            )
          ),
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: Colors.white)
          )
        ]
      ),
    );
  }
}