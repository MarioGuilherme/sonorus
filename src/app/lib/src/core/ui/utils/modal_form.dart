import "package:flutter/material.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";

mixin ModalForm<T extends StatefulWidget> on State<T> {
  void showModalForm({ required String title, required Widget content, List<Widget>? actions }) {
    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16161F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        actions: actions,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: context.textStyles.textBold.withFontSize(24), textAlign: TextAlign.center),
              SizedBox(height: 15),
              ...[content]
            ]
          )
        )
      )
    );
  }
}