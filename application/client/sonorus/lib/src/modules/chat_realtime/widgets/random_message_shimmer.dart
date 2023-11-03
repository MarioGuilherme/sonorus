import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:shimmer/shimmer.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";

class RandomMessageShimmer extends StatelessWidget {
  const RandomMessageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSentByMe = Random().nextBool();
    final double sizeOfMessageContent = (1 + Random().nextInt(180 + 15)).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      margin: isSentByMe ? const EdgeInsets.only(left: 35) : const EdgeInsets.only(right: 35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF404048)
      ),
      child: Shimmer.fromColors(
        baseColor: context.colors.secondary,
        highlightColor: Colors.grey.withAlpha(75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSentByMe)
                    ClipOval(
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.white
                      )
                    ),
                  const SizedBox(width: 10),
                  Container(width: sizeOfMessageContent, height: 12, color: Colors.white),
                ]
              ),
            ),
              const SizedBox(width: 10),
            Container(width: 50, height: 8, color: Colors.white)
          ]
        )
      )
    );
  }
}