import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/core/ui/utils/debouncer.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_controller.dart";
import "package:sonorus/src/modules/base/marketplace/widgets/product.dart";
import "package:sonorus/src/modules/base/marketplace/widgets/random_product_shimmer.dart";

class MarketplacePage extends StatefulWidget {

  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> with Messages, CustomShimmer, SingleTickerProviderStateMixin {
  final MarketplaceController _controller = Modular.get<MarketplaceController>();
  final _searchEC = TextEditingController();
  final debouncer = Debouncer(milliseconds: 500);
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getAllProducts();
    this._statusReactionDisposer = reaction((_) => this._controller.marketplaceStatus, (status) {
      switch (status) {
        case MarketplaceStateStatus.initial:
        case MarketplaceStateStatus.loadingProducts:
        case MarketplaceStateStatus.loadedProducts: break;
        case MarketplaceStateStatus.error:
          this.showMessage("Ops", this._controller.errorMessage ?? "Erro não mapeado");
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._statusReactionDisposer();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: this._controller.getAllProducts,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              textInputAction: TextInputAction.search,
              controller: this._searchEC,
              style: context.textStyles.textRegular.copyWith(color: Colors.white),
              onChanged: (value) {
                debouncer.call(() {
                  this._controller.filterByName(value);
                });
              },
              decoration: const InputDecoration(
                label: Text("Pesquisar"),
                prefixIcon: Icon(Icons.search, color: Colors.white, size: 24)
              )
            ),
            const SizedBox(height: 12),
            Observer(
              builder: (_) {
                if (this._controller.marketplaceStatus == MarketplaceStateStatus.loadingProducts)
                  return StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    children: this.createRandomShimmers(() => const RandomProductShimmer())
                  );
                if (this._controller.products.isEmpty)
                  return Center(
                    child: Text(
                      "Nenhum anúncio encontrado",
                      style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 14.sp),
                    )
                  );
                return StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: this._controller.products.map((product) => StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: Product(product: product)
                  )).toList()
                );
              }
            )
          ]
        )
      )
    );
  }
}