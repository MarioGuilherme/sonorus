import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";

class RandomOpportunityShimmer extends StatelessWidget {
  const RandomOpportunityShimmer({ super.key });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.secondary,
      highlightColor: Colors.grey.withAlpha(75),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF404048)
        ),
        child: SizedBox(height: 80)
      )
    );
  }
}