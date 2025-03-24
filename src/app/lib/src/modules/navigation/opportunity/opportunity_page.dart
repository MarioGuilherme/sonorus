import "package:brasil_fields/brasil_fields.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/extensions/size_extensions.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/widgets/header_tab_content.dart";
import "package:sonorus/src/dtos/view_models/opportunity_view_model.dart";
import "package:sonorus/src/modules/navigation/opportunity/opportunity_controller.dart";
import "package:sonorus/src/modules/navigation/opportunity/widgets/opportunity.dart";
import "package:sonorus/src/modules/navigation/opportunity/widgets/opportunity_form.dart";
import "package:sonorus/src/modules/navigation/opportunity/widgets/opportunity_modal.dart";
import "package:sonorus/src/modules/navigation/opportunity/widgets/random_opportunity_shimmer.dart";

class OpportunityPage extends StatefulWidget {
  const OpportunityPage({ super.key });

  @override
  State<OpportunityPage> createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> with Messages, CustomShimmer, Loader {
  final OpportunityController _controller = Modular.get<OpportunityController>();
  final TextEditingController _nameEC = TextEditingController();
  final TextEditingController _descriptionEC = TextEditingController();
  final TextEditingController _paymentEC = TextEditingController();
  final TextEditingController _experienceRequiredEC = TextEditingController();
  final TextEditingController _bandNameEC = TextEditingController();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getAllWithQuery();
    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) {
      switch (status) {
        case OpportunityPageStatus.initial:
        case OpportunityPageStatus.loadingOpportunities:
        case OpportunityPageStatus.loadedOpportunities: break;
        case OpportunityPageStatus.savedOpportunity:
          this.switchShowForm(showForm: false);
          this.hideLoader();
          this._controller.getAllWithQuery();
          this.showQuestionMessage(
            title:"Sucesso!",
            message: "Sua oportunidade foi salva, deseja visualizá-la?",
            onConfirmButtonPressed: () {
              Modular.to.pop();
              this.showOpportunity(this._controller.savedOpportunity!);
            },
            onCancelButtonPressed: () {
              Modular.to.pop();
              this._controller.removeSavedOpportunity();
            }
          );
          break;
        case OpportunityPageStatus.deletingOpportunity:
        case OpportunityPageStatus.savingOpportunity:
          this.showLoader();
          break;
        case OpportunityPageStatus.deletedOpportunity:
          Modular.to.pop();
          Modular.to.pop();
          this.hideLoader();
          this.showSuccessMessage("Oportunidade encerrada e removida com sucesso!");
          this._controller.getAllWithQuery();
          break;
        case OpportunityPageStatus.error:
          this.hideLoader();
          this.showErrorMessage(this._controller.error);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._statusReactionDisposer();
    super.dispose();
  }

  void bindForm(OpportunityViewModel opportunityViewModel) {
    this.switchShowForm(showForm: true);
    this._controller.setOpportunityId(opportunityViewModel.opportunityId);
    this._controller.toggleIsWork(isWork: opportunityViewModel.isWork);
    this._controller.setWorkTimeUnit(opportunityViewModel.workTimeUnit);
    this._nameEC.text = opportunityViewModel.name;
    this._descriptionEC.text = opportunityViewModel.description ?? "";
    this._paymentEC.text = UtilBrasilFields.obterReal(opportunityViewModel.payment);
    this._bandNameEC.text = opportunityViewModel.bandName ?? "";
    this._experienceRequiredEC.text = opportunityViewModel.experienceRequired;
  }

  void clearForm() {
    this._controller.setOpportunityId(null);
    this._controller.setWorkTimeUnit(null);
    this._controller.toggleIsWork(isWork: true);
    this._nameEC.clear();
    this._descriptionEC.clear();
    this._experienceRequiredEC.clear();
    this._bandNameEC.clear();
    this._paymentEC.clear();
  }

  void switchShowForm({ bool? showForm }) {
    this.clearForm();
    this._controller.toggleShowForm(showForm);
  }

  void showOpportunity(OpportunityViewModel opportunityViewModel) => showDialog(
    context: this.context,
    builder: (context) => OpportunityModal(
      opportunityViewModel: opportunityViewModel,
      onPressedEditButton: () {
        Modular.to.pop();
        this.bindForm(opportunityViewModel);
      },
      onPressedDeleteButton: () => this.showQuestionMessage(
        title: "Tem certeza?",
        message: "Ao definir esta oportunidade como preenchida, ele será removida das oportunidades existentes, deseja prosseguir?",
        onConfirmButtonPressed: () async => this._controller.deleteOpportunityById(opportunityViewModel.opportunityId)
      )
    )
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Observer(
            builder: (context) => HeaderTabContent(
              entityName: "OPORTUNIDADE",
              showForm: this._controller.showForm,
              isEdit: this._controller.opportunityId != null,
              onCallDebouncer: this._controller.getAllWithQuery,
              onUpdatedShowForm: () {
                this.clearForm();
                this._controller.toggleShowForm(null);
              }
            )
          ),
          const SizedBox(height: 12),
          Observer(
            builder: (_) {
              if (this._controller.showForm)
                return OpportunityForm(
                  nameEC: this._nameEC,
                  paymentEC: this._paymentEC,
                  experienceRequiredEC: this._experienceRequiredEC,
                  descriptionEC: this._descriptionEC,
                  bandNameEC: this._bandNameEC,
                  workTimeUnit: this._controller.workTimeUnit,
                  isWork: this._controller.isWork,
                  setWorkTimeUnit: (workTimeUnit) => this._controller.setWorkTimeUnit(workTimeUnit),
                  onTapCheckbox: () {
                    this._bandNameEC.clear();
                    this._controller.setWorkTimeUnit(null);
                    this._controller.toggleIsWork();
                  },
                  onSubmitValid: () async => this._controller.saveOpportunity(
                    this._controller.opportunityId != null,
                    this._nameEC.text,
                    this._descriptionEC.text,
                    this._bandNameEC.text,
                    this._experienceRequiredEC.text,
                    UtilBrasilFields.converterMoedaParaDouble(this._paymentEC.text)
                  )
                );
      
              if (this._controller.status == OpportunityPageStatus.loadingOpportunities)
                return StaggeredGrid.count(
                  crossAxisCount: 1,
                  crossAxisSpacing: 5,
                  children: this.createRandomShimmers(() => const RandomOpportunityShimmer())
                );
      
              if (this._controller.opportunities.isEmpty)
                return Center(
                  child: Text(
                    "Nenhuma oportunidade de trabalho encontrada",
                    textAlign: TextAlign.center,
                    style: context.textStyles.textMedium.withFontSize(14)
                  )
                );
      
              return RefreshIndicator(
                onRefresh: this._controller.getAllWithQuery,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: context.percentHeight(.705),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: this._controller.opportunities.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12.5),
                    itemBuilder: (_, i) => Opportunity(onPressedShowOpportunity: showOpportunity, opportunityViewModel: this._controller.opportunities[i])
                  )
                ),
              );
            }
          )
        ]
      )
    );
  }
}