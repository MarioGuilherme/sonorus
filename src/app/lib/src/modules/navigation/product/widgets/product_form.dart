import "dart:io";

import "package:brasil_fields/brasil_fields.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:image_picker/image_picker.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:validatorless/validatorless.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/domain/enums/condition_type.dart";
import "package:sonorus/src/dtos/view_models/media_view_model.dart";
import "package:sonorus/src/modules/navigation/post/widgets/video_media_post.dart";

class ProductForm extends StatefulWidget {
  final TextEditingController nameEC;
  final TextEditingController descriptionEC;
  final TextEditingController priceEC;
  final ConditionType conditionType;
  final void Function(ConditionType) setConditionType;
  final List<XFile> newMedias;
  final List<MediaViewModel> oldMedias;
  final void Function(List<XFile>) addNewMedias;
  final void Function(MediaViewModel) removeOldMedia;
  final void Function(XFile) removeNewMedia;
  final Future<void> Function() onSubmitValid;

  const ProductForm({
    required this.nameEC,
    required this.descriptionEC,
    required this.priceEC,
    required this.conditionType,
    required this.setConditionType,
    required this.newMedias,
    required this.oldMedias,
    required this.addNewMedias,
    required this.removeOldMedia,
    required this.removeNewMedia,
    required this.onSubmitValid,
    super.key
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

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
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: this.widget.nameEC,
                style: context.textStyles.textRegular,
                validator: Validatorless.multiple([
                  Validatorless.required("O nome do produto é obrigatório."),
                  Validatorless.max(50, "O nome pode ter no máximo 50 caracteres.")
                ]),
                decoration: InputDecoration(
                  label: Text("Nome do produto", style: context.textStyles.textBold.withFontSize(18)),
                  prefixIcon: const Icon(Icons.inventory_2, size: 24),
                  isDense: true
                )
              ),
              const SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                controller: this.widget.descriptionEC,
                style: context.textStyles.textRegular,
                validator: Validatorless.max(255, "A descrição do produto pode ter no máximo 255 caracteres."),
                decoration: InputDecoration(
                  label: Text("Descrição", style: context.textStyles.textBold.withFontSize(18)),
                  prefixIcon: const Icon(Icons.description, size: 24),
                  isDense: true
                )
              ),
              const SizedBox(height: 20),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(moeda: true),
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: this.widget.priceEC,
                style: context.textStyles.textRegular,
                validator: Validatorless.required("O preço do produto é obrigatório."),
                decoration: InputDecoration(
                  label: Text("Preço", style: context.textStyles.textBold.withFontSize(18)),
                  prefixIcon: const Icon(Icons.attach_money, size: 24),
                  isDense: true
                )
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Condição: ", style: context.textStyles.textBold.withFontSize(18)),
                  const SizedBox(width: 30),
                  DropdownButton<ConditionType>(
                    icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                    isDense: true,
                    value: this.widget.conditionType,
                    style: context.textStyles.textMedium.copyWith(fontSize: 14.sp, color: context.colors.primary),
                    underline: Container(),
                    onChanged: (value) => this.widget.setConditionType(value!),
                    items: const [
                      DropdownMenuItem<ConditionType>(
                        value: ConditionType.new_,
                        child: Text("Novo")
                      ),
                      DropdownMenuItem<ConditionType>(
                        value: ConditionType.semiUsed,
                        child: Text("Semi-Usado")
                      ),
                      DropdownMenuItem<ConditionType>(
                        value: ConditionType.used,
                        child: Text("Usado")
                      )
                    ]
                  )
                ]
              ),
              const SizedBox(height: 10),
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
                            icon: Icon(Icons.delete),
                            onPressed: () => media.runtimeType == MediaViewModel
                              ? this.widget.removeOldMedia(media as MediaViewModel)
                              : this.widget.removeNewMedia(media as XFile)
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
                    this.widget.addNewMedias(
                      this.widget.newMedias.length + medias.length > 5
                        ? medias.sublist(0, 5 - this.widget.newMedias.length)
                        : medias
                    );
                  }
                ),
                const SizedBox(height: 5),
                Text("No máximo 5 mídias", textAlign: TextAlign.center, style: context.textStyles.textRegular.withFontSize(12))
              ]
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