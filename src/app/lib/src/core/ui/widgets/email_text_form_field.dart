import "package:flutter/material.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";

class EmailTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? errors;

  const EmailTextFormField({
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
      Validatorless.required("O e-mail precisa ser informado!"),
      Validatorless.max(100, "O e-mail não pode exceder 100 caracteres!"),
      Validatorless.email("Informe um e-mail válido!")
    ]),
    decoration: InputDecoration(
      errorText: this.errors,
      label: const Text("E-mail"),
      prefixIcon: const Icon(Icons.mail, size: 24),
      isDense: true
    )
  );
}