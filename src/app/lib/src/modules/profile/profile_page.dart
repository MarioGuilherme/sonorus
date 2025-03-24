import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/extensions/size_extensions.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/modal_form.dart";
import "package:sonorus/src/core/ui/widgets/email_text_form_field.dart";
import "package:sonorus/src/core/ui/widgets/fullname_text_form_field.dart";
import "package:sonorus/src/core/ui/widgets/interest_tag.dart";
import "package:sonorus/src/core/ui/widgets/nickname_text_form_field.dart";
import "package:sonorus/src/core/ui/widgets/password_text_form_field.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/modules/profile/profile_controller.dart";
import "package:sonorus/src/modules/profile/widgets/interest.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({ super.key });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with Messages, Loader, ModalForm {
  final ProfileController _controller = Modular.get<ProfileController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameEC = TextEditingController();
  final TextEditingController _nicknameEC = TextEditingController();
  final TextEditingController _emailEC = TextEditingController();
  final TextEditingController _passwordEC = TextEditingController();
  final TextEditingController _confirmPasswordEC = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getMyInterests();
    this.syncData();
    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) async {
      switch (status) {
        case ProfilePageStatus.initial:
        case ProfilePageStatus.loadedMyInterests:
        case ProfilePageStatus.loadingMyInterests:
          break;
        case ProfilePageStatus.updatingPicture:
        case ProfilePageStatus.exiting:
        case ProfilePageStatus.deletingUser:
        case ProfilePageStatus.loadingAllInterests:
          this.showLoader();
          break;
        case ProfilePageStatus.updatingUserData:
        case ProfilePageStatus.updatingPassword:
          Modular.to.pop();
          this.showLoader();
          break;
        case ProfilePageStatus.loadedAllInterests:
          this.hideLoader();
          this.showModalForm(
            title: "Adicionar interesses",
            content: Padding(
              padding: const EdgeInsets.all(12),
              child: Observer(
                builder: (_) => Wrap(
                  children: this._controller.allInterests.where((i) => !this._controller.myInterests.any((mi) => i.interestId == mi.interestId)).map((nmi) => InterestTag(
                    interestKey: nmi.key!,
                    onPressed: () => this._controller.associateInterest(nmi)
                  )).toList()
                )
              )
            )
          );
          break;
        case ProfilePageStatus.updatedUserData:
          this.hideLoader();
          this.showSuccessMessage("Suas informações foram atualizadas com sucesso!");
          break;
        case ProfilePageStatus.updatedPicture:
          this.hideLoader();
          this.showSuccessMessage("Sua foto foi atualizada com sucesso!");
          break;
        case ProfilePageStatus.updatedPassword:
          this._passwordEC.clear();
          this._confirmPasswordEC.clear();
          this.hideLoader();
          this.showSuccessMessage("Sua senha foi atualizada com sucesso!");
          break;
        case ProfilePageStatus.deletedUser:
        case ProfilePageStatus.exited:
          this.hideLoader();
          Modular.to.navigate("/login/");
          break;
        case ProfilePageStatus.error:
          this.hideLoader();
          this.showErrorMessage(this._controller.error);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._statusReactionDisposer();
    super.dispose();
  }

  void syncData() {
    final AuthenticatedUser authenticatedUser = Modular.get();
    this._controller.setFieldsFromSession(authenticatedUser);
    this._fullnameEC.text = authenticatedUser.fullname!;
    this._nicknameEC.text = authenticatedUser.nickname!;
    this._emailEC.text = authenticatedUser.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Observer(builder: (context) => Text(this._controller.nickname!, style: context.textStyles.textBold.withFontSize(16))),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Observer(
                      builder: (context) => Image.network(
                        this._controller.picture!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                          ? child
                          : SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null
                              )
                            )
                          )
                      )
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0, .8),
                          end: Alignment(0, 0),
                          colors: [
                            Color.fromRGBO(0, 0, 0, .6),
                            Color.fromRGBO(0, 0, 0, 0)
                          ]
                        )
                      )
                    )
                  ]
                )
              )
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Observer(
                    builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("E-mail", textAlign: TextAlign.justify, style: context.textStyles.textBold.withFontSize(16)),
                        Text(this._controller.email!, textAlign: TextAlign.justify, style: context.textStyles.textRegular.withFontSize(12)),
                        const SizedBox(height: 10),
                        Text("Apelido", textAlign: TextAlign.justify, style: context.textStyles.textBold.withFontSize(16)),
                        Text(this._controller.nickname!, textAlign: TextAlign.justify, style: context.textStyles.textRegular.withFontSize(12)),
                        const SizedBox(height: 10),
                        Text("Nome completo", textAlign: TextAlign.justify, style: context.textStyles.textBold.withFontSize(16)),
                        Text(this._controller.fullname!, textAlign: TextAlign.justify, style: context.textStyles.textRegular.withFontSize(12)),
                        const SizedBox(height: 10),
                        Text("Meus interesses", textAlign: TextAlign.justify, style: context.textStyles.textBold.withFontSize(16)),
                        Observer(
                          builder: (_) => this._controller.status == ProfilePageStatus.loadingMyInterests
                            ? Center(child: SizedBox(height: 30, child: CircularProgressIndicator()))
                            : Container(
                              height: 45,
                              width: context.percentWidth(.9),
                              decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                              padding: const EdgeInsets.all(5),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ...this._controller.myInterests.map((i) => Interest(interestKey: i.key!, onTap: () => this._controller.disassociateInterest(i))),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: IconButton(icon: const Icon(Icons.add, size: 16), onPressed: this._controller.showModalWithInterests)
                                  )
                                ]
                              )
                            )
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          label: const Text("Editar meus dados"),
                          icon: const Icon(Icons.edit_note_sharp),
                          onPressed: () {
                            this.syncData();
                            this.showModalForm(
                              title: "Editar dados",
                              content: Form(
                                key: this._formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FullnameTextFormField(textEditingController: this._fullnameEC),
                                    const SizedBox(height: 10),
                                    NicknameTextFormField(textEditingController: this._nicknameEC),
                                    const SizedBox(height: 10),
                                    EmailTextFormField(textEditingController: this._emailEC),
                                    const SizedBox(height: 10)
                                  ]
                                )
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                                  label: const Text("Salvar"),
                                  icon: const Icon(Icons.save),
                                  onPressed: () {
                                    final bool formValid = this._formKey.currentState?.validate() ?? false;
                                    if (!formValid) return;
                                    this._controller.updateUserData(
                                      this._fullnameEC.text.trim(),
                                      this._nicknameEC.text.trim(),
                                      this._emailEC.text.trim()
                                    );
                                  }
                                )
                              ]
                            );
                          }
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          label: const Text("Trocar Foto"),
                          icon: const Icon(Icons.photo_size_select_large_outlined),
                          onPressed: () async {
                            final XFile? pickedFile = await this._picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile == null) return;
                            await this._controller.updatePicture(pickedFile);
                          }
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          label: const Text("Trocar Senha"),
                          icon: const Icon(Icons.edit),
                          onPressed: () => this.showModalForm(
                            title: "Atualizar senha",
                            content: Form(
                              key: this._formKey,
                              child: Column(
                                children: [
                                  PasswordTextFormField(textEditingController: this._passwordEC, isNewPassowrd: true),
                                  const SizedBox(height: 10),
                                  PasswordTextFormField(
                                    textEditingController: this._confirmPasswordEC,
                                    isConfirmPassowrd: true,
                                    isNewPassowrd: true,
                                    textEditingControllerBasePassword: this._passwordEC
                                  )
                                ]
                              )
                            ),
                            actions: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                                label: const Text("Salvar"),
                                icon: const Icon(Icons.save),
                                onPressed: () {
                                  final bool formValid = this._formKey.currentState?.validate() ?? false;
                                  if (!formValid) return;
                                  this._controller.updatePassword(this._passwordEC.text);
                                }
                              )
                            ]
                          )
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          label: const Text("Excluir minha conta"),
                          icon: const Icon(Icons.delete_forever),
                          onPressed: () => this.showQuestionMessage(
                            title: "Tem certeza?",
                            message: "Apagar sua conta resultará em exclusão de todas as suas interações, isto é uma ação irreversível, deseja prosseguir?",
                            onConfirmButtonPressed: this._controller.deleteMyAccount
                          )
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          label: const Text("Sair"),
                          icon: const Icon(Icons.logout),
                          onPressed: () => this.showQuestionMessage(
                            title: "Tem certeza?",
                            message: "Deseja realmente sair?",
                            onConfirmButtonPressed: this._controller.signout
                          )
                        )
                      ]
                    )
                  )
                )
              ])
            )
          ]
        )
      )
    );
  }
}