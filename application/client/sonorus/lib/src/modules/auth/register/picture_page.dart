import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/core/utils/routes.dart";
import "package:sonorus/src/modules/auth/register/picture_controller.dart";
import "package:sonorus/src/modules/base/widgets/picture_user.dart";

class PicturePage extends StatefulWidget {
  const PicturePage({ super.key });

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> with Loader, Messages {
  final PictureController _controller = Modular.get<PictureController>();
  final ImagePicker _picker = ImagePicker();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._statusReactionDisposer = reaction((_) => this._controller.pictureStatus, (status) {
      switch (status) {
        case PictureStateStatus.initial:
          break;
        case PictureStateStatus.loading:
          this.showLoader();
          break;
        case PictureStateStatus.success:
          this.hideLoader();
          Modular.to.navigate(Routes.interestsPage);
          break;
        case PictureStateStatus.error:
          this.hideLoader();
          this.showMessage("Ops", this._controller.errorMessage ?? "Erro não mapeado");
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._statusReactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.secondary,
      body: Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: Text(
                          "Defina sua foto de perfil",
                          textAlign: TextAlign.center,
                          style: context.textStyles.textBold.copyWith(color: Colors.white, fontSize: 24)
                        )
                      ),
                      Observer(
                        builder: (_) => Stack(
                          alignment: Alignment.center,
                          children: [
                            PictureUser(
                              picture: this._controller.pictureBytes == null
                                ? Image.network(
                                    "https://cdn-icons-png.flaticon.com/512/1077/1077114.png",
                                    width: context.percentHeight(.35),
                                    height: context.percentHeight(.35),
                                    fit: BoxFit.cover
                                  )
                                : Image.memory(
                                    this._controller.pictureBytes!,
                                    width: context.percentHeight(.35),
                                    height: context.percentHeight(.35),
                                    fit: BoxFit.cover
                                  )
                            ),
                            if (this._controller.pictureBytes != null)
                              Align(
                                widthFactor: context.percentWidth(.01),
                                heightFactor: context.percentHeight(.007),
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: this._controller.removePicture,
                                  child: const Icon(Icons.delete)
                                )
                              )
                          ]
                        )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (this._picker.supportsImageSource(ImageSource.camera))
                            TextButton(
                              onPressed: () async {
                                final XFile? pickedFile = await this._picker.pickImage(source: ImageSource.camera);
                                this._controller.changePictureUser(pickedFile!);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.camera_alt_outlined, color: Color(0xFFF53D63), size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Câmera",
                                    style: context.textStyles.textSemiBold.copyWith(
                                      fontSize: 20,
                                      color: const Color(0xFFF53D63)
                                    )
                                  )
                                ]
                              )
                            ),
                          TextButton(
                            onPressed: () async {
                              final XFile? pickedFile = await this._picker.pickMedia();
                              this._controller.changePictureUser(pickedFile!);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image,
                                  color: Color(0xFFF53D63),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Galeria",
                                  style: context.textStyles.textSemiBold.copyWith(
                                    fontSize: 20,
                                    color: const Color(0xFFF53D63)
                                  )
                                )
                              ]
                            )
                          )
                        ]
                      )
                    ]
                  )
                )
              ),
              SizedBox(
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Observer(
                    builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (this._controller.pictureBytes != null)
                            ElevatedButton(
                              onPressed: this._controller.savePicture,
                              child: const Text("Confirmar")
                            ),
                          const SizedBox(width: 20),
                          OutlinedButton(
                            onPressed: () => Modular.to.navigate(Routes.interestsPage),
                            child: const Text("Definir isto depois")
                          )
                        ]
                      );
                    }
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}