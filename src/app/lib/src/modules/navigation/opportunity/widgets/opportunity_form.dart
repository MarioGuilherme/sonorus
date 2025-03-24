import "package:brasil_fields/brasil_fields.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/domain/enums/work_time_unit.dart";

class OpportunityForm extends StatefulWidget {
  final TextEditingController nameEC;
  final TextEditingController paymentEC;
  final TextEditingController experienceRequiredEC;
  final TextEditingController descriptionEC;
  final TextEditingController bandNameEC;
  final WorkTimeUnit? workTimeUnit;
  final bool isWork;
  final VoidCallback onTapCheckbox;
  final void Function(WorkTimeUnit) setWorkTimeUnit;
  final Future<void> Function() onSubmitValid;

  const OpportunityForm({
    required this.nameEC,
    required this.paymentEC,
    required this.experienceRequiredEC,
    required this.descriptionEC,
    required this.bandNameEC,
    required this.workTimeUnit,
    required this.isWork,
    required this.onTapCheckbox,
    required this.setWorkTimeUnit,
    required this.onSubmitValid,
    super.key
  });

  @override
  State<OpportunityForm> createState() => _OpportunityFormState();
}

class _OpportunityFormState extends State<OpportunityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: this._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: this.widget.nameEC,
                style: context.textStyles.textRegular,
                validator: Validatorless.multiple([
                  Validatorless.required("O nome da oportunidade é obrigatório."),
                  Validatorless.max(50, "O nome pode ter no máximo 50 caracteres.")
                ]),
                decoration: InputDecoration(
                  label: Text("Nome da oportunidade", style: context.textStyles.textBold.withFontSize(18)),
                  prefixIcon: const Icon(Icons.assignment, size: 24),
                  isDense: true
                )
              ),
              const SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: this.widget.experienceRequiredEC,
                style: context.textStyles.textRegular,
                validator: Validatorless.multiple([
                  Validatorless.required("A experiência mínima para a oportunidade é obrigatória."),
                  Validatorless.max(25, "O nome pode ter no máximo 25 caracteres.")
                ]),
                decoration: InputDecoration(
                  label: Text("Experiência requerida", style: context.textStyles.textBold.withFontSize(18)),
                  prefixIcon: const Icon(Icons.verified, size: 24),
                  isDense: true
                )
              ),
              const SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                controller: this.widget.descriptionEC,
                style: context.textStyles.textRegular,
                validator: Validatorless.max(255, "A descrição da oportunidade pode ter no máximo 255 caracteres."),
                decoration: InputDecoration(
                  label: Text("Descrição", style: context.textStyles.textBold.withFontSize(18)),
                  prefixIcon: const Icon(Icons.description, size: 24),
                  isDense: true
                )
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: this.widget.onTapCheckbox,
                child: Row(
                  children: [
                    Checkbox(
                      value: !this.widget.isWork,
                      fillColor: WidgetStateProperty.resolveWith((_) => context.colors.primary.withAlpha(127)),
                      onChanged: (_) => this.widget.onTapCheckbox()
                    ),
                    Text("É para formação de banda?", style: context.textStyles.textBold.withFontSize(18))
                  ]
                )
              ),
              if (!this.widget.isWork) ...[
                const SizedBox(height: 10),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: this.widget.bandNameEC,
                  style: context.textStyles.textRegular,
                  validator: Validatorless.multiple([
                    Validatorless.required("O nome da banda precisa ser informado!"),
                    Validatorless.max(50, "O nome da banda pode no máximo 50 caracteres!")
                  ]),
                  decoration: InputDecoration(
                    label: Text("Nome da banda", style: context.textStyles.textBold.withFontSize(18)),
                    prefixIcon: const Icon(Icons.groups, size: 24),
                    isDense: true
                  )
                ),
              ] else ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Será pago por:", style: context.textStyles.textBold.withFontSize(18)),
                    const SizedBox(width: 30),
                    DropdownButton<WorkTimeUnit>(
                      icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                      isDense: true,
                      value: this.widget.workTimeUnit ?? WorkTimeUnit.perDays,
                      style: context.textStyles.textMedium.copyWith(fontSize: 14.sp, color: context.colors.primary),
                      underline: Container(),
                      onChanged: (value) => this.widget.setWorkTimeUnit(value!),
                      items: const [
                        DropdownMenuItem<WorkTimeUnit>(
                          value: WorkTimeUnit.perDays,
                          child: Text("Dia")
                        ),
                        DropdownMenuItem<WorkTimeUnit>(
                          value: WorkTimeUnit.perHours,
                          child: Text("Horas")
                        ),
                        DropdownMenuItem<WorkTimeUnit>(
                          value: WorkTimeUnit.perShow,
                          child: Text("Show")
                        )
                      ]
                    )
                  ]
                )
              ],
              const SizedBox(height: 20),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(moeda: true)
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: this.widget.paymentEC,
                validator: Validatorless.required("O valor de pagamento é obrigatório."),
                style: context.textStyles.textRegular,
                decoration: InputDecoration(
                  label: Text("Pagamento", style: context.textStyles.textBold.withFontSize(18)),
                  prefixIcon: const Icon(Icons.attach_money, size: 24),
                  isDense: true
                )
              )
            ]
          )
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: const Text("Salvar"),
              onPressed: () async {
                final bool formValid = this._formKey.currentState?.validate() ?? false;
                if (!formValid) return;
                await this.widget.onSubmitValid();
              }
            )
          ]
        ),
        SizedBox(height: 20)
      ]
    )
  );
}