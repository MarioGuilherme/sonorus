
import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/modules/auth/register/register_controller.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({ super.key });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
          break;
        case RegisterStateStatus.success:
          Modular.to.navigate("/register/picture");
          break;
        case RegisterStateStatus.error:
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

  @override
  Widget build(BuildContext context) {
    this._fullnameEC.text = "Mário Guilherme de Andrade Rodrigues";
    this._nicknameEC.text = "dev.mario.guilherme";
    this._emailEC.text = "marioguilhermedev@gmail.com";
    this._passwordEC.text = "123123";
    this._confirmPasswordEC.text = "123123";

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            left: 28,
            right: 28
          ),
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
                      Expanded(
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.cover,
                          height: context.percentHeight(0.3),
                        )
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Preencha os seus dados para criar sua conta",
                        textAlign: TextAlign.center,
                        style: context.textStyles.textBold.copyWith(color: Colors.white)
                      ),
                      const SizedBox(height: 18),
                      Form(
                        key: this._formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: this._fullnameEC,
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("Nome completo"),
                                prefixIcon: Icon(Icons.person, color: Colors.white, size: 24),
                                isDense: true
                              )
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: this._nicknameEC,
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("Nome de usuário (apelido)"),
                                prefixIcon: Icon(Icons.badge, color: Colors.white, size: 24),
                                isDense: true
                              )
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: this._emailEC,
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("E-mail"),
                                prefixIcon: Icon(Icons.mail, color: Colors.white, size: 24),
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
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: this._confirmPasswordEC,
                              obscureText: true,
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                label: const Text("Confirmar senha"),
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
                              _controller.register(
                                this._fullnameEC.text,
                                this._nicknameEC.text,
                                this._emailEC.text,
                                this._passwordEC.text
                              );
                          },
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
                        onTap: () {
                          Navigator.of(context).popAndPushNamed("/login");
                        }
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