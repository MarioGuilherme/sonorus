import "package:flutter/material.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";

class NicknameTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? errors;

  const NicknameTextFormField({
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
      Validatorless.required("O apelido precisa ser informado!"),
      Validatorless.min(7, "O apelido precisa ter no mínimo 7 caracteres!"),
      Validatorless.max(25, "O apelido pode ter no máximo 25 caracteres!"),
      Validatorless.regex(RegExp(r"^[a-z0-9.]{7,25}$"), "O apelido deve conter apenas pontos, números e letras minúsculas sem acentos!")
    ]),
    decoration: InputDecoration(
      errorText: this.errors,
      label: const Text("Nome de usuário (apelido)"),
      prefixIcon: const Icon(Icons.badge, size: 24),
      isDense: true
    )
  );
}