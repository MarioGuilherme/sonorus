import "package:flutter/material.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";

class PasswordTextFormField extends StatefulWidget {
  final TextEditingController textEditingController;
  final TextEditingController? textEditingControllerBasePassword;
  final String? errors;
  final bool isNewPassowrd;
  final bool isConfirmPassowrd;

  const PasswordTextFormField({
    required this.textEditingController,
    this.textEditingControllerBasePassword,
    this.errors,
    this.isNewPassowrd = false,
    this.isConfirmPassowrd = false,
    super.key
  });

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) => TextFormField(
    textInputAction: TextInputAction.next,
    controller: this.widget.textEditingController,
    obscureText: !this.showPassword,
    style: context.textStyles.textRegular,
    validator: Validatorless.multiple([
      Validatorless.required("A ${(this.widget.isNewPassowrd ? "nova " : "")}senha precisa ser informada!"),
      Validatorless.min(6, "A ${(this.widget.isNewPassowrd ? "nova " : "")}senha precisa ter no mínimo 6 caracteres!"),
      if (this.widget.isConfirmPassowrd) Validatorless.compare(this.widget.textEditingControllerBasePassword, "A senhas não coincidem.")
    ]),
    decoration: InputDecoration(
      errorText: widget.errors,
      label: Text("${this.widget.isConfirmPassowrd ? "Confirmar " : ""}${(this.widget.isNewPassowrd ? "Nova " : "")}Senha"),
      isDense: true,
      prefixIcon: const Icon(Icons.lock, size: 24),
      suffixIcon: IconButton(onPressed: () => setState(() => this.showPassword = !this.showPassword), icon: const Icon(Icons.visibility, size: 18))
    )
  );
}