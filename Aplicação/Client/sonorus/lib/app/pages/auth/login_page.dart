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
          padding: const EdgeInsets.all(28),
          height: context.screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover
            )
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover, height: context.percentHeight(.3)
                    ),
                    const SizedBox(height: 26),
                    Text(
                      "Olá, seja bem-vindo(a)",
                      style: context.textStyles.textRegular.copyWith(color: Colors.white, fontSize: 20)
                    ),
                    const SizedBox(height: 21),
                    TextFormField(
                      style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        label: Text("Nome de usuário ou e-mail"),
                        prefixIcon: Icon(Icons.badge, color: Colors.white),
                        isDense: true,
                      )
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        label: const Text("Senha"),
                        isDense: true,
                        prefixIcon: const Icon(Icons.lock, color: Colors.white, size: 24),
                        suffixIcon: IconButton(
                          onPressed: (){ },
                          icon: const Icon(Icons.visibility, size: 18),
                          color: Colors.white
                        )
                      )
                    ),
                    const SizedBox(height: 24),
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
              RichText(
                text: TextSpan(
                  text: "Não tem uma conta? ",
                  style: context.textStyles.textRegular.copyWith(fontSize: 20, color: Colors.white),
                  children: [
                    TextSpan(
                      text: "Cadastre-se",
                      style: context.textStyles.textBold.copyWith(fontSize: 20, color: context.colors.primary)
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}