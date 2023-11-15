import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/modules/base/business/business_page.dart";

class BusinessModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const BusinessPage());
  }
}