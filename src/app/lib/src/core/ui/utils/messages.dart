import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";

mixin Messages<T extends StatefulWidget> on State<T> {
  void showSuccessMessage(String message, { VoidCallback? onConfirm }) => showDialog(
    context: this.context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Sucesso!", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
      content: Text(message, textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(color: Colors.black, fontSize: 16.sp)),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          onPressed: onConfirm ?? Modular.to.pop,
          child: Text("OK", style: context.textStyles.textLight.withFontSize(14))
        )
      ]
    )
  );

  void showMessageWithActions({ required String title, required String message, required List<Widget> actions, bool buttonsInRow = false }) => showDialog(
    context: this.context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(title, textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
      content: Text(message, textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(color: Colors.black, fontSize: 16.sp)),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        buttonsInRow ? Row(mainAxisSize: MainAxisSize.min, children: actions) : Column(children: actions)
      ]
    )
  );

  void showQuestionMessage({ required String title, required String message, required VoidCallback onConfirmButtonPressed, VoidCallback? onCancelButtonPressed }) => showDialog(
    context: this.context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(title, textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
      content: Text(message, textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(color: Colors.black, fontSize: 16.sp)),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton.icon(
          onPressed: onConfirmButtonPressed,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
          label: Text("Sim"),
          icon: Icon(Icons.check)
        ),
        ElevatedButton.icon(
          onPressed: onCancelButtonPressed ?? Modular.to.pop,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
          label: Text("Não"),
          icon: Icon(Icons.cancel)
        )
      ]
    )
  );

  void showErrorMessage(String? message, { VoidCallback? onConfirmButtonPressed }) => showDialog(
    context: this.context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Ops!", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
      content: Text(message ?? "Erro desconhecido!", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(color: Colors.black, fontSize: 16.sp)),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          onPressed: onConfirmButtonPressed ?? Modular.to.pop,
          child: Text("OK", style: context.textStyles.textLight.withFontSize(14))
        )
      ]
    )
  );
}