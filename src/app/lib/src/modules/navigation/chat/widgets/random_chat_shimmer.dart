import "dart:math";

import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";

class RandomChatShimmer extends StatelessWidget {
  const RandomChatShimmer({ super.key });

  @override
  Widget build(BuildContext context) {
    final double sizeOfFriendName = (1 + Random().nextInt(190 + 10)).toDouble();
    final double sizeOfLastMessage = (1 + Random().nextInt(190 + 10)).toDouble();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10.5),
      decoration: BoxDecoration(color: const Color(0xFF404048), borderRadius: BorderRadius.circular(15)),
      child: Shimmer.fromColors(
        baseColor: context.colors.secondary,
        highlightColor: Colors.grey.withAlpha(75),
        child: Row(
          children: [
            ClipOval(child: Container(height: 50, width: 50, color: Colors.white)),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: sizeOfFriendName, height: 12, color: Colors.white),
                    const SizedBox(height: 10),
                    Container(width: sizeOfLastMessage, height: 8, color: Colors.white)
                  ]
                )
              )
            ),
            Container(width: 50, height: 8, color: Colors.white)
          ]
        )
      )
    );
  }
}