import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";
import "package:sonorus/src/core/utils/routes.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/modules/auth/register/register_controller.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({ super.key });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with Loader, Messages {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  final _fullnameEC = TextEditingController();
  final _nicknameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _controller = Modular.get<RegisterController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._statusReactionDisposer = reaction((_) => this._controller.registerStatus, (status) {
      switch (status) {
        case RegisterStateStatus.initial:
          break;
        case RegisterStateStatus.loading:
          this.showLoader();
          break;
        case RegisterStateStatus.success:
          this.hideLoader();
          Modular.to.navigate(Routes.picturePage);
          break;
        case RegisterStateStatus.error:
          this.hideLoader();
          this.showMessage("Ops", this._controller.errorMessage ?? "Erro não mapeado");
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._fullnameEC.dispose();
    this._nicknameEC.dispose();
    this._emailEC.dispose();
    this._passwordEC.dispose();
    this._confirmPasswordEC.dispose();
    this._statusReactionDisposer();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final bool formValid = this._formKey.currentState?.validate() ?? false;
    if (formValid)
      await this._controller.register(
        this._fullnameEC.text,
        this._nicknameEC.text,
        this._emailEC.text,
        this._passwordEC.text
      );
  }

  @override
  Widget build(BuildContext context) {
    this._fullnameEC.text = "Mário Guilherme de Andrade Rodrigues";
    this._emailEC.text = "marioguilhermedev@gmail.com";
    this._nicknameEC.text = "dev.mario.guilherme";
    this._passwordEC.text = "123123123";
    this._confirmPasswordEC.text = "123123123";

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          height: context.screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover
            )
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: context.percentHeight(.2),
                        child: Image.asset("assets/images/logo.png", fit: BoxFit.cover)
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Preencha os seus dados para criar sua conta",
                        textAlign: TextAlign.center,
                        style: context.textStyles.textBold.copyWith(color: Colors.white)
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: Form(
                          key: this._formKey,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  Observer(
                                    builder: (_) => TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: this._fullnameEC,
                                      style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                      validator: Validatorless.multiple([
                                        Validatorless.required("O nome precisa ser informado."),
                                        Validatorless.max(100, "O nome não pode exceder 100 caracteres.")
                                      ]),
                                      decoration: InputDecoration(
                                        errorText: this._controller.fullnameInputErrors,
                                        label: const Text("Nome completo"),
                                        prefixIcon: const Icon(Icons.person, color: Colors.white, size: 24),
                                        isDense: true
                                      )
                                    )
                                  ),
                                  const SizedBox(height: 16),
                                  Observer(
                                    builder: (_) => TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: this._nicknameEC,
                                      style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                      validator: Validatorless.multiple([
                                        Validatorless.required("O apelido precisa ser informado."),
                                        Validatorless.min(7, "O apelido precisa ter no mínimo 7 caracteres."),
                                        Validatorless.max(25, "O apelido pode ter no máximo 25 caracteres."),
                                        Validatorless.regex(RegExp(r"^[a-z0-9.]{7,25}$"), "O apelido deve conter apenas pontos, números e letras minúsculas sem acentos.")
                                      ]),
                                      decoration: InputDecoration(
                                        errorText: this._controller.nicknameInputErrors,
                                        label: const Text("Nome de usuário (apelido)"),
                                        prefixIcon: const Icon(Icons.badge, color: Colors.white, size: 24),
                                        isDense: true
                                      )
                                    )
                                  ),
                                  const SizedBox(height: 16),
                                  Observer(
                                    builder: (_) => TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: this._emailEC,
                                      style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                      validator: Validatorless.multiple([
                                        Validatorless.required("O e-mail precisa ser informado."),
                                        Validatorless.max(100, "O e-mail não pode exceder 100 caracteres."),
                                        Validatorless.email("Informe um e-mail válido.")
                                      ]),
                                      decoration: InputDecoration(
                                        errorText: this._controller.emailInputErrors,
                                        label: const Text("E-mail"),
                                        prefixIcon: const Icon(Icons.mail, color: Colors.white, size: 24),
                                        isDense: true
                                      )
                                    )
                                  ),
                                  const SizedBox(height: 16),
                                  Observer(
                                    builder: (_) => StatefulBuilder(
                                      builder: (context, setState) => TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: this._passwordEC,
                                        obscureText: !this._showPassword,
                                        style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                        validator: Validatorless.multiple([
                                          Validatorless.required("A senha precisa ser informada."),
                                          Validatorless.min(6, "A senha precisa ter no mínimo 6 caracteres.")
                                        ]),
                                        decoration: InputDecoration(
                                          errorText: this._controller.passwordInputErrors,
                                          label: const Text("Senha"),
                                          isDense: true,
                                          prefixIcon: const Icon(Icons.lock, color: Colors.white, size: 24),
                                          suffixIcon: IconButton(
                                            onPressed: () => setState(() => this._showPassword = !this._showPassword),
                                            icon: const Icon(Icons.visibility, size: 18),
                                            color: Colors.white
                                          )
                                        )
                                      )
                                    )
                                  ),
                                  const SizedBox(height: 16),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return TextFormField(
                                        textInputAction: TextInputAction.send,
                                        controller: this._confirmPasswordEC,
                                        obscureText: !this._showConfirmPassword,
                                        style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                        onFieldSubmitted: (_) => this._submitForm(),
                                        validator: Validatorless.multiple([
                                          Validatorless.required("A senha de confirmação precisa ser informada."),
                                          Validatorless.min(6, "A senha precisa ter no mínimo 6 caracteres."),
                                          Validatorless.compare(this._passwordEC, "A senhas não coincidem.")
                                        ]),
                                        decoration: InputDecoration(
                                          label: const Text("Confirmar senha"),
                                          isDense: true,
                                          prefixIcon: const Icon(Icons.lock, color: Colors.white, size: 24),
                                          suffixIcon: IconButton(
                                            onPressed: () => setState(() => this._showConfirmPassword = !this._showConfirmPassword),
                                            icon: const Icon(Icons.visibility, size: 18),
                                            color: Colors.white
                                          )
                                        )
                                      );
                                    }
                                  )
                                ]
                              )
                            )
                          )
                        )
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: this._submitForm,
                          child: const Text("Cadastrar")
                        )
                      )
                    ]
                  )
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Já tem uma conta?",
                        style: context.textStyles.textRegular.copyWith(color: Colors.white)
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        child: Text(
                          "Faça login",
                          style: context.textStyles.textBold.copyWith(color: context.colors.primary)
                        ),
                        onTap: () => Modular.to.navigate(Routes.loginPage)
                      )
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}