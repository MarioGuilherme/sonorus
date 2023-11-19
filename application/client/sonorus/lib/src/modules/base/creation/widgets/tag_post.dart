import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";

class TagPost extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final void Function() onPressed;

  const TagPost({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: context.colors.primary.withOpacity(this.isSelected ? .6 : .25),
          child: InkWell(
            onTap: this.onPressed,
            child: Ink(
              padding: const EdgeInsets.all(4.5),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text(
                "#${this.tag}",
                style: context.textStyles.textBold.copyWith(
                  color: context.colors.primary, fontSize: 12.sp,
                  decoration: TextDecoration.underline
                )
              )
            )
          )
        )
      )
    );
  }
}