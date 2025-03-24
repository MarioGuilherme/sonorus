import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/extensions/size_extensions.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/widgets/password_text_form_field.dart";
import "package:sonorus/src/modules/login/login_controller.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Loader, Messages {
  final TextEditingController _loginEC = TextEditingController();
  final TextEditingController _passwordEC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final LoginController _controller = Modular.get<LoginController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.redirectIfAuthenticated();
    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) {
      switch (status) {
        case LoginPageStatus.initial:
        case LoginPageStatus.loading:
          this.showLoader();
          break;
        case LoginPageStatus.success:
          this.hideLoader();
          Modular.to.navigate(Modular.initialRoute);
          break;
        case LoginPageStatus.error:
          this.hideLoader();
          if (this._controller.error != null) this.showErrorMessage(this._controller.error);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._loginEC.dispose();
    this._passwordEC.dispose();
    this._statusReactionDisposer();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final bool formValid = this._formKey.currentState?.validate() ?? false;
    if (formValid) this._controller.login(this._loginEC.text, this._passwordEC.text);
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
                      Image.asset("assets/images/logo.png", fit: BoxFit.cover, height: context.percentHeight(.3)),
                      const SizedBox(height: 24),
                      Text("Olá, seja bem-vindo(a)", textAlign: TextAlign.center, style: context.textStyles.textBold.withFontSize(18)),
                      const SizedBox(height: 18),
                      Form(
                        key: this._formKey,
                        child: Observer(
                          builder: (context) => Column(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: this._loginEC,
                                style: context.textStyles.textRegular,
                                validator: Validatorless.required("Informe o seu apelido ou e-mail."),
                                decoration: InputDecoration(
                                  errorText: this._controller.loginInputErrors,
                                  label: const Text("Apelido ou e-mail"),
                                  prefixIcon: const Icon(Icons.badge, size: 24),
                                  isDense: true
                                )
                              ),
                              const SizedBox(height: 16),
                              PasswordTextFormField(textEditingController: this._passwordEC, errors: this._controller.passwordInputErrors)
                            ]
                          )
                        )
                      ),
                      const SizedBox(height: 18),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: this._submitForm, child: const Text("Entrar")))
                    ]
                  )
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Não tem uma conta?", style: context.textStyles.textRegular.withFontSize(16)),
                      const SizedBox(width: 10),
                      InkWell(
                        child: Text("Cadastre-se", style: context.textStyles.textBold.copyWith(color: context.colors.primary, fontSize: 16.sp)),
                        onTap: () => Modular.to.navigate("/register/")
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