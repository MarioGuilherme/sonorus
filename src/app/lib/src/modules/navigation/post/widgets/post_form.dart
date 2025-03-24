import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/dtos/view_models/media_view_model.dart";
import "package:sonorus/src/modules/navigation/post/widgets/video_media_post.dart";
import "package:sonorus/src/modules/profile/widgets/interest.dart";

class PostForm extends StatefulWidget {
  final TextEditingController contentEC;
  final TextEditingController tablatureEC;
  final List<InterestDto> allTags;
  final List<InterestDto> selectedTags;
  final void Function(InterestDto) disassociateTag;
  final List<XFile> newMedias;
  final List<MediaViewModel> oldMedias;
  final void Function(List<XFile>) associateTag;
  final void Function(MediaViewModel) removeOldMedia;
  final void Function(XFile) removeNewMedia;
  final Future<void> Function() showModalWithTags;
  final Future<void> Function() onSubmitValid;

  const PostForm({
    required this.contentEC,
    required this.tablatureEC,
    required this.allTags,
    required this.selectedTags,
    required this.disassociateTag,
    required this.newMedias,
    required this.oldMedias,
    required this.associateTag,
    required this.removeOldMedia,
    required this.removeNewMedia,
    required this.showModalWithTags,
    required this.onSubmitValid,
    super.key
  });

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  void maskTablature(String value) {
    const stringAcronyms = ["e", "B", "G", "D", "A", "E", "B", "F#"];
    value = value.replaceAll(RegExp("[${stringAcronyms.join("")}| ]"), "");
    final strings = value.split("\n").sublist(0, value.split("\n").length > 8 ? 8 : value.split("\n").length);

    for (var i = 0; i < strings.length; i++) {
      final remain = strings[i];
      final acronymCompleted = stringAcronyms[i].padRight(3, " ");
      strings[i] = "$acronymCompleted| $remain";
    }

    final result = strings.join(" |\n");
    final previousSelection = this.widget.tablatureEC.selection;
    this.widget.tablatureEC.text = result;
    this.widget.tablatureEC.selection = previousSelection;
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: this._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),
              TextFormField(
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                controller: this.widget.contentEC,
                style: context.textStyles.textRegular,
                validator: Validatorless.max(255, "o conteúdo da publicação pode ter no máximo 255 caracteres."),
                decoration: InputDecoration(
                  label: Text("Conteúdo", style: context.textStyles.textBold.withFontSize(18)),
                  prefixIcon: const Icon(Icons.edit_note, size: 24),
                  isDense: true
                )
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Tags", style: context.textStyles.textBold.withFontSize(18)),
                  const SizedBox(width: 5),
                  Text("(Isso ajuda a filtrar a publicação)", style: context.textStyles.textMedium.withFontSize(10))
                ]
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                padding: const EdgeInsets.all(5),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...this.widget.selectedTags.map((st) => Interest(interestKey: st.key!, onTap: () => this.widget.disassociateTag(st))),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashColor: context.colors.primary,
                          icon: const Icon(Icons.add, size: 16),
                          onPressed: this.widget.showModalWithTags
                        )
                      )
                    )
                  ]
                )
              ),
              const SizedBox(height: 15),
              Text("Mídias", style: context.textStyles.textBold.withFontSize(18)),
              [...this.widget.oldMedias, ...this.widget.newMedias].isEmpty
                ? Container(
                    height: 129,
                    decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                    child: Center(child: Text("Suas mídias aparecerão aqui", style: context.textStyles.textRegular.withFontSize(12)))
                  )
                : GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10),
                    children: [...this.widget.oldMedias, ...this.widget.newMedias].map((media) => Stack(
                      alignment: Alignment.center,
                      children: [
                        media.runtimeType == MediaViewModel
                          ? Image.network((media as MediaViewModel).path, fit: BoxFit.contain)
                          : (media as XFile).path.split(".")[5] == "mp4"
                              ? VideoMediaPost(media.path)
                              : Image.file(File(media.path), fit: BoxFit.contain),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton.filled(
                            onPressed: () => media.runtimeType == MediaViewModel ? this.widget.removeOldMedia(media as MediaViewModel) : this.widget.removeNewMedia(media as XFile),
                            icon: Icon(Icons.delete)
                          )
                        )
                      ]
                    )).toList()
                  ),
              if (this.widget.newMedias.length < 5) ...[
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text("Anexar fotos ou vídeos"),
                  onPressed: () async {
                    final List<XFile> medias = await this._picker.pickMultipleMedia();
                    this.widget.associateTag(this.widget.newMedias.length + medias.length > 5 ? medias.sublist(0, 5 - this.widget.newMedias.length) : medias);
                  }
                ),
                SizedBox(height: 5),
                Text("Máximo de 5 mídias", textAlign: TextAlign.center, style: context.textStyles.textMedium.withFontSize(11)),
                Text("Formatos aceitos: jpg, jpeg, png e mp4", textAlign: TextAlign.center, style: context.textStyles.textMedium.withFontSize(11))
              ],
              const SizedBox(height: 15),
              ElevatedButton.icon(
                label: const Text("Anexar tablatura"),
                icon: const Icon(Icons.music_note),
                onPressed: () async {
                  showDialog(
                    context: context,
                    useSafeArea: true,
                    builder: (context) => Scaffold(
                      body: PopScope(
                        canPop: true,
                        onPopInvokedWithResult: (didPop, result) async => SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  child: const Icon(Icons.close),
                                  onPressed: () async {
                                    await SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);
                                    Modular.to.pop();
                                  }
                                ),
                                const SizedBox(height: 5),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: IntrinsicWidth(
                                    stepWidth: 1000,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller: this.widget.tablatureEC,
                                      style: context.textStyles.textMediumMono.copyWith(color: Colors.black),
                                      validator: Validatorless.max(255, "A tablatura pode ter no máximo 1000 caracteres."),
                                      decoration: const InputDecoration(isDense: true),
                                      onChanged: this.maskTablature
                                    )
                                  )
                                )
                              ]
                            )
                          )
                        )
                      )
                    )
                  );
                  await SystemChrome.setPreferredOrientations([ DeviceOrientation.landscapeLeft ]);
                }
              ),
              SizedBox(height: 5),
              Text("Caso não queira anexar, deixe o campo em branco", textAlign: TextAlign.center, style: context.textStyles.textMedium.withFontSize(11))
            ]
          )
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: const Text("Salvar"),
              onPressed: () async {
                final bool formValid = this._formKey.currentState?.validate() ?? false;
                if (!formValid) return;
                await this.widget.onSubmitValid();
              }
            )
          ]
        ),
        SizedBox(height: 20)
      ]
    )
  );
}