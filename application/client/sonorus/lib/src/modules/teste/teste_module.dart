import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/modules/teste/teste_controller.dart";
import "package:sonorus/src/modules/teste/teste_page.dart";

class TesteModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => TesteController());
  }

  @override
  void routes(r) {
    r.child("/", child: (context) => const TestePage());
  }
}