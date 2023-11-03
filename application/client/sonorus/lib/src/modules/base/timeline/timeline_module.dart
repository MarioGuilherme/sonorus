import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/base/timeline/timeline_page.dart";

class TimelineModule extends Module {
  @override
  void routes(r) => r.child("/", child: (context) => const TimelinePage());
}