import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/base/creation/creation_page.dart";

class CreationModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (context) => const CreationPage());
  }
}