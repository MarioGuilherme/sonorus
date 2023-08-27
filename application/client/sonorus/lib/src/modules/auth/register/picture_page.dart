import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/modules/auth/register/picture_controller.dart";

class PicturePage extends StatefulWidget {
  const PicturePage({ super.key });

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  final _controller = Modular.get<PictureController>();
  final ImagePicker _picker = ImagePicker();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._statusReactionDisposer = reaction((_) => this._controller.pictureStatus, (status) {
      switch (status) {
        case PictureStateStatus.initial:
          break;
        case PictureStateStatus.loading:
          break;
        case PictureStateStatus.success:
          Modular.to.navigate("/register/interests");
          break;
        case PictureStateStatus.error:
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(300.0),
                        child: CircleAvatar(
                          radius: context.percentHeight(.225),
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Observer(
                              builder: (_) => this._controller.picture == null
                                ? Image.network("https://cdn-icons-png.flaticon.com/512/1077/1077114.png")
                                : Image.file(
                                  File(this._controller.picture!.path),
                                  // errorBuilder: (BuildContext context, Object error,
                                  //     StackTrace? stackTrace) {
                                  //   return const Center(
                                  //       child:
                                  //           Text("This image type is not supported"));
                                  // },
                                )
                            )
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (_picker.supportsImageSource(ImageSource.camera))
                            TextButton(
                              onPressed: () async {
                                final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                                this._controller.changePictureUser(pickedFile!);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.camera_alt_outlined,
                                    color: Color(0xFFF53D63),
                                    size: 20
                                  ),
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
                              final XFile? pickedFile = await _picker.pickMedia();
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Observer(
                          builder: (_) => ElevatedButton(
                            onPressed: this._controller.picture == null
                              ? null
                              : this._controller.savePicture,
                            child: const Text("Confirmar")
                          )
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("/timeline");
                          },
                          child: const Text("Depois")
                        ),
                      )
                    ]
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }
}