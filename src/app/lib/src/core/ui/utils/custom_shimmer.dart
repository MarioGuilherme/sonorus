import "dart:math";

import "package:flutter/material.dart";

mixin CustomShimmer<T extends StatelessWidget> {
  List<Widget> createRandomShimmers(Widget Function() shimmerInvocator) {
    return List.filled(Random().nextInt(10) + 5, Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: shimmerInvocator()
    ));
  }
}