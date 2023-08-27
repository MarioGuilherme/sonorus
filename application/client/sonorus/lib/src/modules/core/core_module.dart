import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/core/http/http_client.dart";

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.lazySingleton((i) => HttpClient(), export: true),
  ];
}