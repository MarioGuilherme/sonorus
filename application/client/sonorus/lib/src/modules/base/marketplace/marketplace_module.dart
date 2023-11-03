import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_page.dart";
import "package:sonorus/src/modules/base/product/product_page.dart";

class MarketplaceModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const MarketplacePage());
    r.child("/:productId", child: (_) => ProductPage(product: r.args.data));
  }
}