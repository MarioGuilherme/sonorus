import "package:flutter/material.dart";
import "package:sonorus/app/core/ui/styles/colors_app.dart";

import "package:sonorus/app/core/ui/styles/text_styles.dart";
import "package:sonorus/app/core/ui/utils/size_extensions.dart";

class RegisterPage extends StatelessWidget {
  const RegisterPage({ super.key });

  @override
  Widget build(BuildContext context) {
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
                        child: Column(
                          children: [
                            TextFormField(
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("Nome completo"),
                                prefixIcon: Icon(Icons.person, color: Colors.white, size: 24),
                                isDense: true
                              )
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("Nome de usuário (apelido)"),
                                prefixIcon: Icon(Icons.badge, color: Colors.white, size: 24),
                                isDense: true
                              )
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("E-mail"),
                                prefixIcon: Icon(Icons.mail, color: Colors.white, size: 24),
                                isDense: true
                              )
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
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
                            Navigator.of(context).popAndPushNamed("/interests");
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