import "package:flutter/material.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";

class FullnameTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? errors;

  const FullnameTextFormField({
    required this.textEditingController,
    this.errors,
    super.key
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    textInputAction: TextInputAction.next,
    controller: this.textEditingController,
    style: context.textStyles.textRegular,
    validator: Validatorless.multiple([
      Validatorless.required("O nome precisa ser informado!"),
      Validatorless.max(100, "O nome não pode exceder 100 caracteres!")
    ]),
    decoration: InputDecoration(
      errorText: this.errors,
      label: const Text("Nome completo"),
      prefixIcon: const Icon(Icons.person, size: 24),
      isDense: true
    )
  );
}