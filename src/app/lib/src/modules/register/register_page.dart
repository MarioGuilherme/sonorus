import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/extensions/size_extensions.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/widgets/email_text_form_field.dart";
import "package:sonorus/src/core/ui/widgets/fullname_text_form_field.dart";
import "package:sonorus/src/core/ui/widgets/nickname_text_form_field.dart";
import "package:sonorus/src/core/ui/widgets/password_text_form_field.dart";
import "package:sonorus/src/modules/register/register_controller.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({ super.key });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with Loader, Messages {
  final RegisterController _controller = Modular.get<RegisterController>();
  final TextEditingController _fullnameEC = TextEditingController();
  final TextEditingController _nicknameEC = TextEditingController();
  final TextEditingController _emailEC = TextEditingController();
  final TextEditingController _passwordEC = TextEditingController();
  final TextEditingController _confirmPasswordEC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) {
      switch (status) {
        case RegisterPageStatus.initial:
          break;
        case RegisterPageStatus.loading:
          this.showLoader();
          break;
        case RegisterPageStatus.success:
          this.hideLoader();
          Modular.to.navigate("/register/picture");
          break;
        case RegisterPageStatus.error:
          this.hideLoader();
          this.showErrorMessage(this._controller.error);
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
    if (!formValid) return;
    this._controller.register(
      this._fullnameEC.text,
      this._nicknameEC.text,
      this._emailEC.text,
      this._passwordEC.text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          height: context.screenHeight,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: context.percentHeight(.3), child: Image.asset("assets/images/logo.png", fit: BoxFit.cover)),
                      const SizedBox(height: 18),
                      Text("Preencha os seus dados para criar sua conta", textAlign: TextAlign.center, style: context.textStyles.textBold),
                      const SizedBox(height: 18),
                      Expanded(
                        child: Form(
                          key: this._formKey,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Observer(
                                builder: (context) => Column(
                                  children: [
                                    FullnameTextFormField(textEditingController: this._fullnameEC, errors: this._controller.fullnameInputErrors),
                                    const SizedBox(height: 16),
                                    NicknameTextFormField(textEditingController: this._nicknameEC, errors: this._controller.nicknameInputErrors),
                                    const SizedBox(height: 16),
                                    EmailTextFormField(textEditingController: this._emailEC, errors: this._controller.emailInputErrors),
                                    const SizedBox(height: 16),
                                    PasswordTextFormField(textEditingController: this._passwordEC, errors: this._controller.passwordInputErrors),
                                    const SizedBox(height: 16),
                                    PasswordTextFormField(textEditingController: this._confirmPasswordEC, isConfirmPassowrd: true, textEditingControllerBasePassword: this._passwordEC)
                                  ]
                                )
                              )
                            )
                          )
                        )
                      ),
                      const SizedBox(height: 18),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: this._submitForm, child: const Text("Cadastrar")))
                    ]
                  )
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Já tem uma conta?", style: context.textStyles.textRegular),
                      const SizedBox(width: 10),
                      InkWell(
                        child: Text("Faça login", style: context.textStyles.textBold.copyWith(color: context.colors.primary)),
                        onTap: () => Modular.to.navigate("/login/")
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