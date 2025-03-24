import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";

class Interest extends StatelessWidget {
  final String interestKey;
  final VoidCallback? onTap;

  const Interest({
    required this.interestKey,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: this.onTap,
            child: Ink(
              padding: const EdgeInsets.all(4.5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Text(
                "#$interestKey",
                style: context.textStyles.textSemiBold.copyWith(color: context.colors.primary, fontSize: 11.sp)
              )
            )
          )
        )
      )
    )
  );
}