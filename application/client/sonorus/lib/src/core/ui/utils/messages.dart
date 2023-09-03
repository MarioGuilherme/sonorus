import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";

mixin Messages<T extends StatefulWidget> on State<T> {
  void showMessage(String title, String message) {
    showDialog(
      barrierDismissible: true,
      context: this.context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(fontSize: 20.sp)),
        content: Text(message, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20))
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
          )
        ]
      )
    );
  }
}