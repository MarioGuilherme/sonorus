import "dart:async";

import "package:flutter/material.dart";

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({ required this.milliseconds });

  void call(VoidCallback callback) {
    this._timer?.cancel();
    this._timer = Timer(Duration(milliseconds: milliseconds), callback);
  }
}