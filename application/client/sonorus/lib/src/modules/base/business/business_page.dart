import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/debouncer.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/modules/base/business/business_controller.dart";
import "package:sonorus/src/modules/base/business/widgets/opportunity.dart";

class BusinessPage extends StatefulWidget {
  const BusinessPage({ super.key });

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> with Messages {
  final BusinessController _controller = Modular.get<BusinessController>();
  final _searchEC = TextEditingController();
  final debouncer = Debouncer(milliseconds: 500);
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getAllOpportunities();
    this._statusReactionDisposer = reaction((_) => this._controller.businessStatus, (status) {
      switch (status) {
        case BusinessStateStatus.initial:
        case BusinessStateStatus.loadingOpportunities:
        case BusinessStateStatus.updatedOpportunity:
        case BusinessStateStatus.updatingOpportunity:
        case BusinessStateStatus.loadedOpportunities: break;
        case BusinessStateStatus.error:
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
      onRefresh: this._controller.getAllOpportunities,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
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
            ),
            const SizedBox(height: 12),
            Observer(
              builder: (_) {
                if (this._controller.businessStatus == BusinessStateStatus.loadingOpportunities)
                  return Center(
                    child: Text(
                      "Carregando",
                      style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 14.sp)
                    )
                  );
                  // return StaggeredGrid.count(
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 5,
                  //   crossAxisSpacing: 5,
                  //   children: this.createRandomShimmers(() => const RandomProductShimmer())
                  // );
                if (this._controller.opportunities.isEmpty)
                  return Center(
                    child: Text(
                      "Nenhuma oportunidade de projeto/trabalho encontrado",
                      textAlign: TextAlign.center,
                      style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 14.sp),
                    )
                  );
                return Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: context.screenHeight - 210,
                  child: ListView.separated(
                    // controller: this._scrollController,
                    shrinkWrap: true,
                    itemCount: this._controller.opportunities.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12.5),
                    itemBuilder: (_, i) => Opportunity(opportunity: this._controller.opportunities[i])
                  ),
                );
              }
            )
          ]
        )
      )
    );
  }
}