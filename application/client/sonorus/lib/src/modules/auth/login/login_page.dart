import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/modules/auth/login/login_controller.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nicknameOrEmailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _controller = Modular.get<LoginController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._statusReactionDisposer = reaction((_) => this._controller.loginStatus, (status) {
      switch (status) {
        case LoginStateStatus.initial:
          // TODO: Handle this case.
          break;
        case LoginStateStatus.loading:
          // showLoader();
          break;
        case LoginStateStatus.success:
          log("Login certo");
          // hideLoader();
          // Modular.to.navigate("/");
          break;
        case LoginStateStatus.error:
          // hideLoader();
          // showError(controller.errorMessage ?? 'Erro');
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._nicknameOrEmailEC.dispose();
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
                        style: context.textStyles.textBold.copyWith(color: Colors.white)
                      ),
                      const SizedBox(height: 18),
                      Form(
                        key: this._formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: this._nicknameOrEmailEC,
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("Apelido ou e-mail"),
                                prefixIcon: Icon(Icons.badge, color: Colors.white, size: 24),
                                isDense: true
                              )
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: this._passwordEC,
                              obscureText: true,
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                label: const Text("Senha"),
                                isDense: true,
                                prefixIcon: const Icon(Icons.lock, color: Colors.white, size: 24),
                                suffixIcon: IconButton(
                                  onPressed: () { },
                                  icon: const Icon(Icons.visibility, size: 18),
                                  color: Colors.white
                                )
                              )
                            )
                          ]
                        )
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final formValid = this._formKey.currentState?.validate() ?? false;

                            if (formValid)
                              _controller.login(this._nicknameOrEmailEC.text, this._passwordEC.text);
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