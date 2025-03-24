import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";

class InterestTag extends StatelessWidget {
  final String interestKey;
  final VoidCallback onPressed;

  const InterestTag({
    super.key,
    required this.interestKey,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: this.onPressed,
            child: Ink(
              padding: const EdgeInsets.all(4.5),
              decoration: BoxDecoration(color: Colors.white.withAlpha(100), borderRadius: BorderRadius.circular(12)),
              child: Text("#${this.interestKey}", style: context.textStyles.textBold.copyWith(color: context.colors.primary, fontSize: 12.sp))
            )
          )
        )
      )
    );
  }
}