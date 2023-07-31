import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sonorus/app/core/rest_client/custom_dio.dart";

class ApplicationBinding extends StatelessWidget {
  final Widget child;

  const ApplicationBinding({
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <Provider>[
        Provider<CustomDio>(create: (BuildContext context) => CustomDio())
      ],
      child: this.child
    );
  }
}