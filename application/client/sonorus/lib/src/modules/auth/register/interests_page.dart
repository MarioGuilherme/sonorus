import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/utils/routes.dart";
import "package:sonorus/src/models/interest_type.dart";
import "package:sonorus/src/modules/auth/register/interests_controller.dart";
import "package:sonorus/src/modules/auth/register/widget/multi_selector.dart";

class InterestsPage extends StatefulWidget {

  const InterestsPage({ super.key });

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> with Loader, Messages {
  final _controller = Modular.get<InterestsController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getAllInterests();
    this._statusReactionDisposer = reaction((_) => this._controller.interestStatus, (status) {
      switch (status) {
        case InterestStateStatus.initial:
          break;
        case InterestStateStatus.loadingInterests:
          break;
        case InterestStateStatus.loadedInterests:
          break;
        case InterestStateStatus.savingInterests:
          this.showLoader();
          break;
        case InterestStateStatus.savedInterests:
          this.hideLoader();
          Modular.to.navigate(Routes.timelinePage);
          break;
        case InterestStateStatus.error:
          this.hideLoader();
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
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: context.colors.secondary,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 75,
                    width: double.infinity,
                    child: Text(
                      "Selecione os seus interesses",
                      textAlign: TextAlign.center,
                      style: context.textStyles.textBold.copyWith(color: Colors.white, fontSize: 24)
                    )
                  ),
                  Observer(
                    builder: (_) => MultiSelector(
                      title: "Gêneros Musicais",
                      allItens: this._controller.interests?.where((interest) => interest.type == InterestType.musicalGenre).toList(),
                      selecteds: this._controller.selectedInterests.where((interest) => interest.type == InterestType.musicalGenre).toList(),
                    )
                  ),
                  Observer(
                    builder: (_) => MultiSelector(
                      title: "Bandas ou artistas",
                      allItens: this._controller.interests?.where((interest) => interest.type == InterestType.bandOrArtist).toList(),
                      selecteds: this._controller.selectedInterests.where((interest) => interest.type == InterestType.bandOrArtist).toList()
                    )
                  ),
                  Observer(
                    builder: (_) => MultiSelector(
                      title: "Instrumentos",
                      allItens: this._controller.interests?.where((interest) => interest.type == InterestType.instrument).toList(),
                      selecteds: this._controller.selectedInterests.where((interest) => interest.type == InterestType.instrument).toList()
                    )
                  ),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Observer(
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: this._controller.selectedInterests.length < 3
                                ? null
                                : this._controller.saveInterests,
                              style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: context.colors.primary.withAlpha(50),
                                disabledForegroundColor: context.colors.primary.withAlpha(150)
                              ),
                              child: const Text("Salvar interesses")
                            );
                          }
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Selecione no mínimo 3 items do seu interesses",
                          textAlign: TextAlign.center,
                          style: context.textStyles.textExtraBold.copyWith(color: context.colors.primary, fontSize: 12.sp)
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Você poderá editar isso depois",
                          textAlign: TextAlign.center,
                          style: context.textStyles.textExtraBold.copyWith(fontSize: 10.sp)
                        )
                      ]
                    )
                  )
                ]
              )
            )
          )
        );
      }
    );
  }
}