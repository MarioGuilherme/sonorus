import "package:flutter/material.dart";
import "package:sonorus/app/core/ui/styles/colors_app.dart";
import "package:sonorus/app/core/ui/styles/text_styles.dart";
import "package:sonorus/app/pages/auth/register/widget/multi_selector.dart";


class InterestsPage extends StatelessWidget {
  final List<Map<String, String>> _bands = [
    { "red-hot-chili-peppers": "Red Hot Chili Peppers" },
    { "nirvana": "Nirvana" },
    { "foo-Fighters": "Foo Fighters" },
    { "pearl-jam": "Pearl Jam" },
    { "audioslave": "Audioslave" },
    { "ac-dc": "AC/DC" },
    { "guns-and-rosess": "Guns N' Roses" },
    { "queen": "Queen" }
  ];

  final List<Map<String, String>> _musicalGenres = [
    { "rock": "Rock" },
    { "alternative-rock": "Rock Alternativo" },
    { "punk": "Punk" },
    { "funky": "Funky" },
    { "pop": "POP" },
    { "mpb": "MPB" },
    { "eletronic": "Eletrônica" },
    { "samba": "Samba" },
    { "pagode": "Pagode" },
    { "forro": "Forró" },
    { "reggae": "Reggae" },
  ];

  final List<Map<String, String>> _instruments = [
    { "Guitar": "Guitarra" },
    { "Contrabass": "Contrabaixo" },
    { "Piano": "Piano" },
    { "vocal": "Vocal" },
    { "cavaquinho": "Cavaquinho" },
    { "ukulele": "Ukulele" },
    { "drum": "Bateria" },
    { "Keyboard": "Teclado" },
    { "flute": "Flauta" },
    { "violin": "Violino" },
    { "cello": "Violoncelo" },
  ];

  InterestsPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.secondary,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 75,
                  width: double.infinity,
                  child: Text(
                    "Preencha os seus interesses",
                    textAlign: TextAlign.center,
                    style: context.textStyles.textBold.copyWith(color: Colors.white, fontSize: 24)
                  )
                ),
                MultiSelector(title: "Gêneros Musicais", items: this._musicalGenres),
                MultiSelector(title: "Bandas", items: this._bands),
                MultiSelector(title: "Instrumentos", items: this._instruments),
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("/timeline");
                        },
                        child: const Text("Salvar interesses")
                      ),
                      const SizedBox(height: 15),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("/timeline");
                        },
                        child: const Text("Depois eu faço isso")
                      )
                    ]
                  )
                )
              ]
            ),
          )
        )
    );
  }
}