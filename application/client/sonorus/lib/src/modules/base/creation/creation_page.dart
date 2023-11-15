import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:brasil_fields/brasil_fields.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/models/condition_type.dart";
import "package:sonorus/src/models/creation_type_enum.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/interest_type.dart";
import "package:sonorus/src/models/work_time_unit.dart";
import "package:sonorus/src/modules/auth/register/widget/multi_selector.dart";
import "package:sonorus/src/modules/base/creation/creation_controller.dart";
import "package:sonorus/src/modules/base/creation/widgets/tag_post.dart";
import "package:sonorus/src/modules/base/timeline/widgets/hash_tag.dart";
import "package:sonorus/src/modules/base/timeline/widgets/video_media_post.dart";
import "package:validatorless/validatorless.dart";

class CreationPage extends StatefulWidget {
  const CreationPage({ super.key });

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> with Messages, Loader {
  final CreationController _controller = Modular.get<CreationController>();
  final ImagePicker _picker = ImagePicker();
  late final ReactionDisposer _statusReactionDisposer;

  // Post
  final TextEditingController _postContentEC = TextEditingController();
  final TextEditingController _tablatureEC = TextEditingController();

  // Produto
  final TextEditingController _productNameEC = TextEditingController();
  final TextEditingController _productDescriptionEC = TextEditingController();
  final TextEditingController _productPriceEC = TextEditingController();

  // Oportunidade
  final TextEditingController _opportunityNameEC = TextEditingController();
  final TextEditingController _opportunityDescriptionEC = TextEditingController();
  final TextEditingController _opportunityPaymentEC = TextEditingController();
  final TextEditingController _opportunityExperienceEC = TextEditingController();
  final TextEditingController _opportunityBandNameEC = TextEditingController();
  bool _isToBand = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    this._statusReactionDisposer = reaction((_) => this._controller.creationStatus, (status) {
      switch (status) {
        case CreationStateStatus.initial: break;
        case CreationStateStatus.createdOpportunity:
          this.hideLoader();
          this._opportunityNameEC.clear();
          this._productDescriptionEC.clear();
          this._opportunityExperienceEC.clear();
          this._opportunityPaymentEC.clear();
          this._isToBand = false;
          this._controller.toggleWorkTimeUnit(WorkTimeUnit.perShow);
          showDialog(
            barrierDismissible: true,
            context: this.context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text("Sucesso", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
              content: Text("Sua oportunidade foi criada com sucesso", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))
                  ),
                  onPressed: Modular.to.pop,
                  child: Text("Ok", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                )
              ]
            )
          );
          this.hideLoader();
        case CreationStateStatus.creatingPost:
          this.showLoader();
          break;
        case CreationStateStatus.creatingOpportunity:
          this.showLoader();
          break;
        case CreationStateStatus.createdPost:
          this._postContentEC.clear();
          this._tablatureEC.clear();
          this._controller.clearPostMedias();
          this._controller.clearSelectedTags();
          this.hideLoader();
          showDialog(
            barrierDismissible: true,
            context: this.context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text("Sucesso", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
              content: Text("Sua publicação foi criada com sucesso", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))
                  ),
                  onPressed: Modular.to.pop,
                  child: Text("Ok", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                )
              ]
            )
          ); // fUTURA EDição talvez
          break;
        case CreationStateStatus.creatingProduct:
          this.showLoader();
          break;
        case CreationStateStatus.createdProduct:
          this._controller.clearProductMedias();
          this._productDescriptionEC.clear();
          this._productNameEC.clear();
          this._productPriceEC.clear();
          this.hideLoader();
          showDialog(
            barrierDismissible: true,
            context: this.context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text("Sucesso", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
              content: Text("Seu anúncio foi criado, deseja visualizá-lo?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))
                  ),
                  onPressed: () {
                    Modular.to.pop();
                    Modular.to.pushNamed("/marketplace/product", arguments: this._controller.lastProductCreated);
                  },
                  child: Text("Sim", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))
                  ),
                  onPressed: () {
                    this._controller.clearLastProductRegistered();
                    Navigator.pop(context);
                  },
                  child: Text("Não", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                )
              ]
            )
          );
          break;
        case CreationStateStatus.error:
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "O que você deseja criar?",
                style: context.textStyles.textSemiBold.copyWith(color: Colors.white, fontSize: 14.sp)
              ),
              DropdownButton<CreationType?>(
                icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                isDense: true,
                value: this._controller.creationType,
                style: context.textStyles.textMedium.copyWith(fontSize: 14.sp, color: context.colors.primary),
                underline: Container(),
                onChanged: (value) {
                  setState(() {
                    this._controller.toggleTypeCreation(value);
                  });
                },
                items: const [
                  DropdownMenuItem<CreationType?>(
                    value: null,
                    child: Text("Selecione")
                  ),
                  DropdownMenuItem<CreationType?>(
                    value: CreationType.post,
                    child: Text("Publicação")
                  ),
                  DropdownMenuItem<CreationType?>(
                    value: CreationType.product,
                    child: Text("Anúncio")
                  ),
                  DropdownMenuItem<CreationType?>(
                    value: CreationType.opportunity,
                    child: Text("Oportunidade")
                  )
                ]
              )
            ]
          )
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Observer(
              builder: (_) {
                if (this._controller.creationType == null)
                  return Center(
                    child: Text(
                      "Selecione o tipo de conteúdo a ser criado",
                      textAlign: TextAlign.center,
                      style: context.textStyles.textMedium.copyWith(fontSize: 16.sp)
                    )
                  );
                  
                if (this._controller.creationType == CreationType.post)
                  return SingleChildScrollView(
                  child: Column(
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
                              controller: this._postContentEC,
                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                              validator: Validatorless.max(255, "o conteúdo da publicação pode ter no máximo 255 caracteres."),
                              decoration: InputDecoration(
                                label: Text("Conteúdo", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                prefixIcon: const Icon(Icons.edit_note, color: Colors.white, size: 24),
                                isDense: true
                              )
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Tags",
                                  style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "(Isso ajuda a filtrar esta publicação)",
                                  style: context.textStyles.textMedium.copyWith(fontSize: 10.sp)
                                )
                              ]
                            ),
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white
                                )
                              ),
                              padding: const EdgeInsets.all(5),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ...(this._controller.tagsSelectedToPost.map(
                                    (interest) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Material(
                                          color: Colors.white,
                                          child: InkWell(
                                            onTap: () {
                                              this._controller.removeTagSelected(interest);
                                            },
                                            child: Ink(
                                              padding: const EdgeInsets.all(4.5),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withAlpha(100),
                                                borderRadius: BorderRadius.circular(12)
                                              ),
                                              child: Text(
                                                "#${interest.key}",
                                                style: context.textStyles.textSemiBold.copyWith(
                                                  color: context.colors.primary, fontSize: 11.sp,
                                                  decoration: TextDecoration.underline,
                                                  decorationThickness: 4
                                                )
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  ).toList()),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                        onPressed: () {
                                          this._controller.getAllInterests().then((_) {
                                            showDialog(
                                              context: this.context,
                                              builder: (context) => Dialog(
                                                child: Observer(
                                                  builder: (context) {
                                                    return Padding(
                                                      padding: const EdgeInsets.all(12),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Wrap(
                                                            children: this._controller.allTags.where(
                                                              (t) => !this._controller.tagsSelectedToPost.any((element) => t.interestId == element.interestId)
                                                            ).map((tag) => Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 2),
                                                                child: TagPost(
                                                                  tag: tag.key,
                                                                  isSelected: this._controller.tagsSelectedToPost.any((t) => t.interestId == tag.interestId),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      if (this._controller.tagsSelectedToPost.any((t) => t.interestId == tag.interestId))
                                                                        this._controller.removeTagSelected(tag);
                                                                      else
                                                                        this._controller.addTagSelected(tag);
                                                                    });
                                                                  }
                                                                )
                                                              )
                                                            ).toList()
                                                          )
                                                        ]
                                                      )
                                                    );
                                                  }
                                                )
                                              )
                                            );
                                          });
                                        },
                                        splashColor: context.colors.primary,
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16
                                        )
                                      )
                                    )
                                  )
                                ]
                              )
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Mídias",
                              style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                            ),
                            this._controller.postMedia.isEmpty
                              ? Container(
                                height: 129,
                                decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                child: Center(
                                  child: Text(
                                    "Suas mídias aparecerão aqui",
                                    style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                  )
                                )
                              )
                              : GridView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10
                                  ),
                                  children: this._controller.postMedia.map(
                                    (media) => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        media.path.split(".")[5] == "mp4"
                                          ? VideoMediaPost(media.path)
                                          : Image.file(
                                              File(media.path),
                                              fit: BoxFit.contain,
                                            ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            splashRadius: 1,
                                            onPressed: () {
                                              this._controller.removeMediaPost(media);
                                            },
                                            icon: ClipOval(
                                              child: Container(
                                                color: context.colors.primary,
                                                child: const Center(child: Icon(Icons.delete))
                                              )
                                            )
                                          )
                                        )
                                      ]
                                    )
                                  ).toList()
                                ),
                            if (this._controller.postMedia.length < 5) ...[
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  final List<XFile> medias = await this._picker.pickMultipleMedia();
                                  if (this._controller.postMedia.length + medias.length > 5)
                                    this._controller.setMediasPost(medias.sublist(0, 5 - this._controller.postMedia.length));
                                  else
                                    this._controller.setMediasPost(medias);
                                },
                                child: const Text("Anexar fotos ou vídeos")
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "No máximo 5 mídias",
                                textAlign: TextAlign.center,
                                style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                              )
                            ],
                            const SizedBox(height: 15),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.music_note),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  useSafeArea: true,
                                  builder: (context) => Scaffold(
                                    body: WillPopScope(
                                      onWillPop: () async {
                                        await SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);
                                        return true;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        color: Colors.white,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);
                                                  Modular.to.pop();
                                                },
                                                child: const Icon(Icons.close)
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
                                                    // minLines: 5,
                                                    controller: this._tablatureEC,
                                                    style: context.textStyles.textMediumMono.copyWith(color: Colors.black),
                                                    validator: Validatorless.max(255, "A tablatura pode ter no máximo 1000 caracteres."),
                                                    decoration: const InputDecoration(
                                                      isDense: true
                                                    )
                                                  )
                                                ),
                                              )
                                            ]
                                          ),
                                        )
                                      )
                                    ),
                                  )
                                );
                                await SystemChrome.setPreferredOrientations([ DeviceOrientation.landscapeLeft ]);
                              },
                              label: const Text("Anexar tablatura")
                            ),
                            Text(
                              "(Caso não queira anexar, deixe o campo em branco)",
                              textAlign: TextAlign.center,
                              style: context.textStyles.textMedium.copyWith(fontSize: 11.sp)
                            )
                          ]
                        )
                      )
                    ]
                  )
                );
                  
                if (this._controller.creationType == CreationType.opportunity)
                  return Center(
                    child: SingleChildScrollView(
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
                                  controller: this._opportunityNameEC,
                                  style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                  validator: Validatorless.multiple([
                                    Validatorless.required("O nome da oportunidade é obrigatório."),
                                    Validatorless.max(50, "O nome pode ter no máximo 50 caracteres.")
                                  ]),
                                  decoration: InputDecoration(
                                    label: Text("Nome da oportunidade", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                    prefixIcon: const Icon(Icons.assignment, color: Colors.white, size: 24),
                                    isDense: true
                                  )
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: this._opportunityExperienceEC,
                                  style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                  validator: Validatorless.multiple([
                                    Validatorless.required("A experiência mínima para a oportunidade é obrigatória."),
                                    Validatorless.max(25, "O nome pode ter no máximo 25 caracteres.")
                                  ]),
                                  decoration: InputDecoration(
                                    label: Text("Experiência requerida", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                    prefixIcon: const Icon(Icons.verified, color: Colors.white, size: 24),
                                    isDense: true
                                  )
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 5,
                                  controller: this._opportunityDescriptionEC,
                                  style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                  validator: Validatorless.max(255, "A descrição da vaga pode ter no máximo 255 caracteres."),
                                  decoration: InputDecoration(
                                    label: Text("Descrição", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                    prefixIcon: const Icon(Icons.description, color: Colors.white, size: 24),
                                    isDense: true
                                  )
                                ),
                                if (this._isToBand) ...[
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: this._opportunityBandNameEC,
                                    style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                    validator: Validatorless.max(50, "O nome da banda pode no máximo 50 caracteres."),
                                    decoration: InputDecoration(
                                      label: Text("Nome da banda", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                      prefixIcon: const Icon(Icons.groups, color: Colors.white, size: 24),
                                      isDense: true
                                    )
                                  )
                                ],
                                const SizedBox(height: 20),
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CentavosInputFormatter(moeda: true),
                                  ],
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  controller: this._opportunityPaymentEC,
                                  validator: Validatorless.required("O valor de pagamento é obrigatório."),
                                  style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                  decoration: InputDecoration(
                                    label: Text("Pagamento", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                    prefixIcon: const Icon(Icons.attach_money, color: Colors.white, size: 24),
                                    isDense: true
                                  )
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "É para formação de banda?",
                                      style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                                    ),
                                    Checkbox(
                                      value: this._isToBand,
                                      activeColor: context.colors.primary,
                                      fillColor: MaterialStateProperty.resolveWith((_) {
                                        return context.colors.primary.withAlpha(127);
                                      }),
                                      onChanged: (value) {
                                        this._opportunityBandNameEC.clear();
                                        this.setState(() {
                                          this._isToBand = !this._isToBand;
                                        });
                                      }
                                    )
                                  ]
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Será pago por:",
                                      style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                                    ),
                                    const SizedBox(width: 30),
                                    DropdownButton<WorkTimeUnit>(
                                      icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                                      isDense: true,
                                      value: this._controller.workTimeUnit,
                                      style: context.textStyles.textMedium.copyWith(fontSize: 14.sp, color: context.colors.primary),
                                      underline: Container(),
                                      onChanged: (value) {
                                        setState(() {
                                          this._controller.toggleWorkTimeUnit(value ?? WorkTimeUnit.perShow);
                                        });
                                      },
                                      items: const [
                                        DropdownMenuItem<WorkTimeUnit>(
                                          value: WorkTimeUnit.perDays,
                                          child: Text("Dia")
                                        ),
                                        DropdownMenuItem<WorkTimeUnit>(
                                          value: WorkTimeUnit.perHours,
                                          child: Text("Horas")
                                        ),
                                        DropdownMenuItem<WorkTimeUnit>(
                                          value: WorkTimeUnit.perShow,
                                          child: Text("Show")
                                        )
                                      ]
                                    )
                                  ]
                                )
                              ]
                            )
                          )
                        ]
                      )
                    ),
                  );
            
                return Center(
                  child: SingleChildScrollView(
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
                                controller: this._productNameEC,
                                style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                validator: Validatorless.multiple([
                                  Validatorless.required("O nome do produto é obrigatório."),
                                  Validatorless.max(50, "O nome pode ter no máximo 50 caracteres.")
                                ]),
                                decoration: InputDecoration(
                                  label: Text("Nome do produto", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                  prefixIcon: const Icon(Icons.inventory_2, color: Colors.white, size: 24),
                                  isDense: true
                                )
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 5,
                                controller: this._productDescriptionEC,
                                style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                validator: Validatorless.max(255, "A descrição do produto pode ter no máximo 255 caracteres."),
                                decoration: InputDecoration(
                                  label: Text("Descrição", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                  prefixIcon: const Icon(Icons.description, color: Colors.white, size: 24),
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
                                controller: this._productPriceEC,
                                style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                validator: Validatorless.required("O preço do produto é obrigatório."),
                                decoration: InputDecoration(
                                  label: Text("Preço", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                  prefixIcon: const Icon(Icons.attach_money, color: Colors.white, size: 24),
                                  isDense: true
                                )
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Condição",
                                    style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                                  ),
                                  const SizedBox(width: 30),
                                  DropdownButton<ConditionType>(
                                    icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                                    isDense: true,
                                    value: this._controller.conditionType ?? ConditionType.new_,
                                    style: context.textStyles.textMedium.copyWith(fontSize: 14.sp, color: context.colors.primary),
                                    underline: Container(),
                                    onChanged: (value) {
                                      setState(() {
                                        this._controller.toggleConditionProduct(value!);
                                      });
                                    },
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
                              const SizedBox(height: 15),
                              Text(
                                "Mídias",
                                style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                              ),
                              this._controller.productMedia.isEmpty
                                ? Container(
                                  height: 129,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                  child: Center(
                                    child: Text(
                                      "Suas mídias aparecerão aqui",
                                      style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                    )
                                  )
                                )
                                : GridView(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 10
                                    ),
                                    children: this._controller.productMedia.map(
                                      (media) => Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          media.path.split(".")[5] == "mp4"
                                            ? VideoMediaPost(media.path)
                                            : Image.file(
                                                File(media.path),
                                                fit: BoxFit.contain,
                                              ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              splashRadius: 1,
                                              onPressed: () {
                                                this._controller.removeMedia(media);
                                              },
                                              icon: ClipOval(
                                                child: Container(
                                                  color: context.colors.primary,
                                                  child: const Center(child: Icon(Icons.delete))
                                                )
                                              )
                                            )
                                          )
                                        ]
                                      )
                                    ).toList()
                                  ),
                              if (this._controller.productMedia.length < 5) ...[
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    final List<XFile> medias = await this._picker.pickMultipleMedia();
                                    if (this._controller.productMedia.length + medias.length > 5)
                                      this._controller.setMedias(medias.sublist(0, 5 - this._controller.productMedia.length));
                                    else
                                      this._controller.setMedias(medias);
                                  },
                                  child: const Text("Anexar fotos ou vídeos")
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "No máximo 5 mídias",
                                  textAlign: TextAlign.center,
                                  style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                )
                              ]
                            ]
                          )
                        )
                      ]
                    )
                  ),
                );
              }
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(color: Colors.white),
              Observer(
                builder: (_) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey),
                    onPressed: this._controller.creationType == null
                      ? null
                      : this._controller.creationType == CreationType.product
                        ? () async {
                            final bool formValid = this._formKey.currentState?.validate() ?? false;
                            if (this._controller.productMedia.isEmpty) {
                              this.showMessage("Mídia obrigatória", "É necessário anexar no mínimo uma foto ou imagem");
                              return;
                            }
                            if (formValid) {
                              await this._controller.createProduct(
                                this._productNameEC.text,
                                this._productDescriptionEC.text,
                                UtilBrasilFields.converterMoedaParaDouble(this._productPriceEC.text)
                              );
                            }
                          }
                        : this._controller.creationType == CreationType.post
                          ? () async {
                              final bool formValid = this._formKey.currentState?.validate() ?? false;

                              if (this._postContentEC.text.isEmpty && this._controller.postMedia.isEmpty) {
                                this.showMessage("Publicação vazia", "É necessário informar algum conteúdo escrito ou anexar no mínimo uma imagem");
                                return;
                              }

                              if (this._controller.tagsSelectedToPost.isEmpty) {
                                this.showMessage("Sem tags", "É necessário selecionar no mínimo três tags para a publicação");
                                return;
                              }

                              if (formValid) {
                                await this._controller.createPost(
                                  this._postContentEC.text,
                                  this._tablatureEC.text,
                                  this._controller.tagsSelectedToPost.map((t) => t.interestId!).toList(),
                                  this._controller.postMedia
                                );
                              }
                            }
                          : () async {
                            final bool formValid = this._formKey.currentState?.validate() ?? false;

                            if (this._isToBand && this._opportunityBandNameEC.text == "") {
                              showMessage("Ops...", "é necessário informar o nome da banda");
                              return;
                            }

                            if (formValid) {
                              await this._controller.createOpportunity(
                                this._opportunityNameEC.text,
                                this._opportunityDescriptionEC.text,
                                this._isToBand ? this._opportunityBandNameEC.text : null,
                                this._opportunityExperienceEC.text,
                                UtilBrasilFields.converterMoedaParaDouble(this._opportunityPaymentEC.text),
                                this._isToBand
                              );
                            }
                          },
                    child: const Text("Publicar")
                  );
                }
              )
            ]
          )
        )
      ]
    );
  }
}