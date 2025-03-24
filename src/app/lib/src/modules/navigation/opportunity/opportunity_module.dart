import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/navigation/opportunity/opportunity_page.dart";

class OpportunityModule extends Module {
  @override
  void routes(r) => r.child(Modular.initialRoute, child: (_) => OpportunityPage());
}