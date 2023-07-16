import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sonorus/app/core/rest_client/custom_dio.dart";

import "package:sonorus/app/pages/timeline/timeline_page.dart";

class TimelineRouter {
  TimelineRouter._();

  static Widget get page => MultiProvider(
    providers: <Provider>[
      Provider<CustomDio>(create: (BuildContext context) => CustomDio())
    ],
    child: const TimelinePage()
  );
}