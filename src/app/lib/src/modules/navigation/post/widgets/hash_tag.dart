import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";

class HashTag extends StatelessWidget {
  final String hashTag;

  const HashTag(this.hashTag, { super.key });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.white,
          child: InkWell(
            child: Ink(
              padding: const EdgeInsets.all(4.5),
              decoration: BoxDecoration(color: Colors.white.withAlpha(100), borderRadius: BorderRadius.circular(12)),
              child: Text(
                "#${this.hashTag}",
                style: context.textStyles.textSemiBold.copyWith(
                  color: context.colors.primary,
                  fontSize: 11.sp,
                  decoration: TextDecoration.underline,
                  decorationThickness: 4
                )
              )
            )
          )
        )
      )
    );
  }
}