import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/modules/auth/login/login_controller.dart";
import "package:validatorless/validatorless.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Loader, Messages {
  final _loginEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _controller = Modular.get<LoginController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._statusReactionDisposer = reaction((_) => this._controller.loginStatus, (status) {
      switch (status) {
        case LoginStateStatus.initial: break;
        case LoginStateStatus.loading:
          this.showLoader();
          break;
        case LoginStateStatus.success:
          this.hideLoader();
          Modular.to.navigate("/timeline");
          break;
        case LoginStateStatus.error:
          this.hideLoader();
          this.showMessage("Ops", this._controller.errorMessage ?? "Erro não mapeado");
          break;
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

  @override
  Widget build(BuildContext context) {
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
                      Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                        height: context.percentHeight(0.3),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Olá, seja bem-vindo(a)",
                        textAlign: TextAlign.center,
                        style: context.textStyles.textBold.copyWith(color: Colors.white, fontSize: 16.sp)
                      ),
                      const SizedBox(height: 18),
                      Form(
                        key: this._formKey,
                        child: Column(
                          children: [
                            Observer(
                              builder: (context) {
                                return TextFormField(
                                  controller: this._loginEC,
                                  style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                  validator: Validatorless.required("Informe o seu apelido ou e-mail."),
                                  decoration: InputDecoration(
                                    errorText: this._controller.loginInputErrors,
                                    label: const Text("Apelido ou e-mail"),
                                    prefixIcon: const Icon(Icons.badge, color: Colors.white, size: 24),
                                    isDense: true
                                  )
                                );
                              }
                            ),
                            const SizedBox(height: 16),
                            Observer(
                              builder: (context) {
                                return TextFormField(
                                  controller: this._passwordEC,
                                  obscureText: true,
                                  style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                  validator: Validatorless.multiple([
                                    Validatorless.required("Informe a sua senha."),
                                    Validatorless.min(6, "A senha precisar ter no mínimo 6 caracteres")
                                  ]),
                                  decoration: InputDecoration(
                                    errorText: this._controller.passwordInputErrors,
                                    label: const Text("Senha"),
                                    isDense: true,
                                    prefixIcon: const Icon(Icons.lock, color: Colors.white, size: 24),
                                    suffixIcon: IconButton(
                                      onPressed: () { },
                                      icon: const Icon(Icons.visibility, size: 18),
                                      color: Colors.white
                                    )
                                  )
                                );
                              }
                            )
                          ]
                        )
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final bool formValid = this._formKey.currentState?.validate() ?? false;

                            if (formValid)
                              this._controller.login(this._loginEC.text, this._passwordEC.text);
                          },
                          child: const Text("Entrar")
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
                        "Não tem uma conta?",
                        style: context.textStyles.textRegular.copyWith(color: Colors.white)
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        child: Text(
                          "Cadastre-se",
                          style: context.textStyles.textBold.copyWith(color: context.colors.primary)
                        ),
                        onTap: () => Modular.to.navigate("/register")
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