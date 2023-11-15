import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";

mixin Loader<T extends StatefulWidget> on State<T> {
  var isOpen = false;

  void showLoader() {
    if (!isOpen) {
      isOpen = true;

      showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: Align(
            alignment: Alignment.center,
            child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 75)
          )
        )
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