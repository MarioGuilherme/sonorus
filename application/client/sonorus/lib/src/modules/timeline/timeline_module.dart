import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/timeline/timeline_controller.dart";
import "package:sonorus/src/modules/timeline/timeline_page.dart";
import "package:sonorus/src/services/timeline/timeline_service.dart";
import "package:sonorus/src/services/timeline/timeline_service_impl.dart";

class TimelineModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.lazySingleton<TimelineService>((i) => TimelineServiceImpl()),
    Bind.lazySingleton((i) => TimelineController(i()))
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute("/", child: (context, args) => const TimelinePage())
  ];
}