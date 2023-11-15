import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";

class Interest extends StatelessWidget {
  final String interest;

  const Interest(this.interest, { super.key });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(4.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Text(
        this.interest,
        style: context.textStyles.textSemiBold.copyWith(
          color: context.colors.primary,
          fontSize: 12.sp
        )
      )
    );
  }
}