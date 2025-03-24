import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/navigation/product/product_details_page.dart";
import "package:sonorus/src/modules/navigation/product/product_page.dart";

class ProductModule extends Module {
  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: (_) => const ProductPage());
    r.child("/details/:product", child: (_) => ProductDetailsPage(productViewModel: r.args.data));
  }
}