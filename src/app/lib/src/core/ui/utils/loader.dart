import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";

mixin Loader<T extends StatefulWidget> on State<T> {
  bool isOpen = false;

  void showLoader() {
    if (!isOpen) {
      isOpen = true;

      showDialog(
        context: context,
        builder: (context) => PopScope(child: Align(alignment: Alignment.center, child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 75)))
      );
    }
  }

  void hideLoader() {
    if (!isOpen) return;
    isOpen = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void dispose() {
    hideLoader();
    super.dispose();
  }
}