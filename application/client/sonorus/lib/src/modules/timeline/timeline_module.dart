import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/modules/timeline/timeline_page.dart";


class TimelineModule extends Module {
  @override
  List<Bind> get binds => [
    // Bind.lazySingleton<AuthRepository>(
    //   (i) => AuthRepositoryImpl(i()),
    // ),
    // Bind.lazySingleton<LoginService>(
    //   (i) => LoginServiceImpl(i(), i()),
    // ),
    // Bind.lazySingleton(
    //   (i) => LoginController(i()),
    // ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute("/", child: (context, args) => const TimelinePage())
  ];
}
