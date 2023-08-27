import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/modules/auth/register/interests_controller.dart";
import "package:sonorus/src/modules/auth/register/widget/multi_selector.dart";

class InterestsPage extends StatefulWidget {

  const InterestsPage({ super.key });

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final _controller = Modular.get<InterestsController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getAllInterests();
    this._statusReactionDisposer = reaction((_) => this._controller.interestStatus, (status) {
      switch (status) {
        case InterestStateStatus.initial:
          log("Ok");
          print(this._controller.interests);
          break;
        case InterestStateStatus.loading:
          break;
        case InterestStateStatus.success:
          log("salvo");
          Modular.to.navigate("/timeline");
          break;
        case InterestStateStatus.error:
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
    return Scaffold(
      backgroundColor: context.colors.secondary,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Observer(
              builder: (_) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 75,
                    width: double.infinity,
                    child: Text(
                      "Preencha os seus interesses",
                      textAlign: TextAlign.center,
                      style: context.textStyles.textBold.copyWith(color: Colors.white, fontSize: 24)
                    )
                  ),
                  MultiSelector(
                    title: "Gêneros Musicais",
                    items: this._controller.interests.where((interest) => interest.type == InterestType.musicalGenre).toList(),
                    onSelected: (interest) {
                      this._controller.addInterest(interest);
                    },
                  ),
                  MultiSelector(
                    title: "Bandas",
                    items: this._controller.interests.where((interest) => interest.type == InterestType.band).toList(),
                    onSelected: (interest) {
                      this._controller.addInterest(interest);
                    },
                  ),
                  MultiSelector(
                    title: "Habilidades",
                    items: this._controller.interests.where((interest) => interest.type == InterestType.skill).toList(),
                    onSelected: (interest) {
                      this._controller.addInterest(interest);
                    },
                  ),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            this._controller.saveInterests();
                          },
                          child: const Text("Salvar interesses")
                        ),
                        const SizedBox(height: 15),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("/timeline");
                          },
                          child: const Text("Depois eu faço isso")
                        )
                      ]
                    )
                  )
                ]
              ),
            ),
          )
        )
    );
  }
}