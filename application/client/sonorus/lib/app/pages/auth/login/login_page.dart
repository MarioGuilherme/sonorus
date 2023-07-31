import "package:flutter/material.dart";
import "package:sonorus/app/core/ui/styles/colors_app.dart";

import "package:sonorus/app/core/ui/styles/text_styles.dart";
import "package:sonorus/app/core/ui/utils/size_extensions.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({ super.key });

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
                        child: Column(
                          children: [
                            TextFormField(
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                label: Text("Apelido ou e-mail"),
                                prefixIcon: Icon(Icons.badge, color: Colors.white, size: 24),
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
                            )
                          ]
                        )
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed("/timeline");
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
                      InkWell(
                        child: Text(
                          "Cadastre-se",
                          style: context.textStyles.textBold.copyWith(color: context.colors.primary)
                        ),
                        onTap: () {
                          Navigator.of(context).popAndPushNamed("/register");
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