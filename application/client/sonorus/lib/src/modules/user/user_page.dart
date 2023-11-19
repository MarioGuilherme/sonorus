
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:signalr_core/signalr_core.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/user_model.dart";
import "package:sonorus/src/modules/base/business/widgets/opportunity.dart";
import "package:sonorus/src/modules/base/creation/creation_controller.dart";
import "package:sonorus/src/modules/base/creation/widgets/tag_post.dart";
import "package:sonorus/src/modules/base/timeline/widgets/hash_tag.dart";
import "package:sonorus/src/modules/user/widgets/interest.dart";
import "package:sonorus/src/modules/user/user_controller.dart";
import "package:validatorless/validatorless.dart";
import "package:video_thumbnail/video_thumbnail.dart";

class UserPage extends StatefulWidget {
  const UserPage({ super.key });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with Messages, Loader {
  final ImagePicker _picker = ImagePicker();
  final _newFullnameEC = TextEditingController();
  final _newPasswordEC = TextEditingController();
  final _newNicknameEC = TextEditingController();
  final CreationController _creationController = Modular.get<CreationController>();
  final _newEmailEC = TextEditingController();
  final _confirmNewPasswordEC = TextEditingController();
  final UserController _controller = Modular.get<UserController>();
  final CurrentUserModel user = Modular.get();
  final _formKey = GlobalKey<FormState>();
  final bool _showConfirmPassword = false;
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.setNewFields(user.fullName!, user.nickname!, user.email!);
    this._controller.setPicture(user.picture!);
    this._newFullnameEC.text = this.user.fullName!;
    this._newNicknameEC.text = this.user.nickname!;
    this._newEmailEC.text = this.user.email!;
    this._controller.getAllInterests();
    this._statusReactionDisposer = reaction((_) => this._controller.userPageStatus, (status) async {
      switch (status) {
        case UserPageStateStatus.initial:
        case UserPageStateStatus.loadingUser:
        case UserPageStateStatus.loadedUser:
        case UserPageStateStatus.savingUserData:
        case UserPageStateStatus.savedUserData: break;
        case UserPageStateStatus.error:
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
      backgroundColor: const Color(0xFF16161F),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  this.user.nickname!,
                  style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Observer(
                      builder: (context) {
                        return Image.network(
                          this._controller.currentPicture!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(color: Colors.white,
                                  value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null
                                )
                              )
                            );
                          }
                        );
                      }
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
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "E-mail",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                          ),
                          Text(
                            this._controller.email!,
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Apelido",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                          ),
                          Text(
                            this._controller.nickname!,
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Nome completo",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                          ),
                          Text(
                            this._controller.fullname!,
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Meus interesses",
                            textAlign: TextAlign.justify,
                            style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                          ),
                          Observer(
                            builder: (_) {
                              if (this._controller.userPageStatus == UserPageStateStatus.loadingUser)
                                return const Center(
                                  child: SizedBox(height: 30, child: CircularProgressIndicator())
                                );
                              else
                                return Container(
                                  height: 45,
                                  width: context.percentWidth(.9),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                  padding: const EdgeInsets.all(5),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ...(this._controller.interests.map(
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
                                              this._creationController.getAllInterests().then((_) {
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
                                                                children: this._creationController.allTags.where(
                                                                  (t) => !this._controller.interests.any((element) => t.interestId == element.interestId)
                                                                ).map((tag) => Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                                                    child: TagPost(
                                                                      tag: tag.key,
                                                                      isSelected: this._controller.interests.any((t) => t.interestId == tag.interestId),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          if (this._controller.interests.any((t) => t.interestId == tag.interestId))
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
                                );
                            }
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              showDialog(
                                barrierDismissible: true,
                                context: this.context,
                                builder: (context) => Material(
                                  color: Colors.transparent,
                                  child: AlertDialog(
                                    backgroundColor: const Color(0xFF16161F),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    actionsAlignment: MainAxisAlignment.center,
                                    content: Observer(
                                      builder: (context) {
                                        return Form(
                                          key: this._formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                textInputAction: TextInputAction.next,
                                                controller: this._newFullnameEC,
                                                style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                validator: Validatorless.multiple([
                                                  Validatorless.required("O nome precisa ser informado."),
                                                  Validatorless.max(100, "O nome não pode exceder 100 caracteres.")
                                                ]),
                                                decoration: InputDecoration(
                                                  fillColor: const Color.fromRGBO(85, 85, 87, 1),
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black
                                                    )
                                                  ),
                                                  hintStyle: context.textStyles.textMedium.copyWith(
                                                    color: Colors.white,
                                                    fontSize: 14.sp
                                                  ),
                                                  contentPadding: const EdgeInsets.only(left: 16),
                                                  label: const Text("Nome completo"),
                                                  prefixIcon: const Icon(Icons.person, color: Colors.white, size: 24),
                                                  isDense: true
                                                )
                                              ),
                                            const SizedBox(height: 10),
                                                TextFormField(
                                                  textInputAction: TextInputAction.next,
                                                  controller: this._newNicknameEC,
                                                  style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                  validator: Validatorless.multiple([
                                                    Validatorless.required("O apelido precisa ser informado."),
                                                    Validatorless.min(7, "O apelido precisa ter no mínimo 7 caracteres."),
                                                    Validatorless.max(25, "O apelido pode ter no máximo 25 caracteres."),
                                                    Validatorless.regex(RegExp(r"^[a-z0-9.]{7,25}$"), "O apelido deve conter apenas pontos, números e letras minúsculas sem acentos.")
                                                  ]),
                                                  decoration: InputDecoration(
                                                  fillColor: const Color.fromRGBO(85, 85, 87, 1),
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black
                                                    )
                                                  ),
                                                  hintStyle: context.textStyles.textMedium.copyWith(
                                                    color: Colors.white,
                                                    fontSize: 14.sp
                                                  ),
                                                  contentPadding: const EdgeInsets.only(left: 16),
                                                    label: const Text("Nome de usuário (apelido)"),
                                                    prefixIcon: const Icon(Icons.badge, color: Colors.white, size: 24),
                                                    isDense: true
                                                  )
                                                ),
                                                const SizedBox(height: 10),
                                                  TextFormField(
                                                    textInputAction: TextInputAction.next,
                                                    controller: this._newEmailEC,
                                                    style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                    validator: Validatorless.multiple([
                                                        Validatorless.required("O e-mail precisa ser informado."),
                                                        Validatorless.max(100, "O e-mail não pode exceder 100 caracteres."),
                                                        Validatorless.email("Informe um e-mail válido.")
                                                    ]),
                                                  decoration: InputDecoration(
                                                    fillColor: const Color.fromRGBO(85, 85, 87, 1),
                                                    border: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black
                                                      )
                                                    ),
                                                    hintStyle: context.textStyles.textMedium.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14.sp
                                                    ),
                                                    contentPadding: const EdgeInsets.only(left: 16),
                                                    label: const Text("E-mail"),
                                                    prefixIcon: const Icon(Icons.mail, color: Colors.white, size: 24),
                                                    isDense: true
                                                  )
                                                ),
                                                const SizedBox(height: 10),
                                            ],
                                          ),
                                        );
                                      }
                                    ),
                                    actions: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          final bool formValid = this._formKey.currentState?.validate() ?? false;
                                          if (formValid) {
                                            Modular.to.pop();
                                            this.showLoader();
                                            await this._controller.updateUser(
                                              this._newFullnameEC.text.trim(),
                                              this._newNicknameEC.text.trim(),
                                              this._newEmailEC.text.trim()
                                            );
                                            this._controller.setNewFields(
                                              this._newFullnameEC.text.trim(),
                                              this._newNicknameEC.text.trim(),
                                              this._newEmailEC.text.trim()
                                            );
                                            this.hideLoader();
                                            this.showMessage("Dados atualizados", "Seuas informações foram atualizadas com sucesso");
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(10)
                                        ),
                                        label: const Text("Salvar"),
                                        icon: const Icon(Icons.save)
                                      )
                                    ]
                                  ),
                                )
                              );
                            },
                            label: const Text("Editar meus dados"),
                            icon: const Icon(Icons.edit_note_sharp) 
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final XFile? pickedFile = await this._picker.pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                this.showLoader();
                                await this._controller.updatePicture(pickedFile);
                                this.hideLoader();
                                this.showMessage("Imagem atualizada", "Sua foto foi atualizada com sucesso");
                              }
                            },
                            label: const Text("Trocar Foto"),
                            icon: const Icon(Icons.photo_size_select_large_outlined) 
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: this.context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  actionsAlignment: MainAxisAlignment.center,
                                  content: Form(
                                    key: this._formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return TextFormField(
                                              textInputAction: TextInputAction.send,
                                              controller: this._newPasswordEC,
                                              obscureText: !this._showConfirmPassword,
                                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                              validator: Validatorless.multiple([
                                              Validatorless.required("A nova senha precisa ser informada."),
                                              Validatorless.min(6, "A nova senha precisa ter no mínimo 6 caracteres.")
                                            ]),
                                              decoration: InputDecoration(
                                                hintText: "Informe sua nova senha",
                                                fillColor: const Color.fromRGBO(85, 85, 87, 1),
                                                border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black
                                                  )
                                                ),
                                                hintStyle: context.textStyles.textMedium.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 14.sp
                                                ),
                                                contentPadding: const EdgeInsets.only(left: 16)
                                              )
                                            );
                                          }
                                        ),
                                      const SizedBox(height: 10),
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return TextFormField(
                                              textInputAction: TextInputAction.send,
                                              controller: this._confirmNewPasswordEC,
                                              obscureText: !this._showConfirmPassword,
                                              style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                              validator: Validatorless.multiple([
                                                Validatorless.required("A senha de confirmação precisa ser informada."),
                                                Validatorless.min(6, "A senha precisa ter no mínimo 6 caracteres."),
                                                Validatorless.compare(this._newPasswordEC, "A senhas não coincidem.")
                                              ]),
                                              decoration: InputDecoration(
                                                hintText: "Confirme sua nova senha",
                                                fillColor: const Color.fromRGBO(85, 85, 87, 1),
                                                border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black
                                                  )
                                                ),
                                                hintStyle: context.textStyles.textMedium.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 14.sp
                                                ),
                                                contentPadding: const EdgeInsets.only(left: 16)
                                              )
                                            );
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        final bool formValid = this._formKey.currentState?.validate() ?? false;
                                        if (formValid) {
                                          Modular.to.pop();
                                          this.showLoader();
                                          await this._controller.updatePassword(this._newPasswordEC.text.trim());
                                          this._confirmNewPasswordEC.clear();
                                          this._newPasswordEC.clear();
                                          this.hideLoader();
                                          this.showMessage("Senha atualizada", "Sua senha foi atualizada com sucesso");
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(10)
                                      ),
                                      label: const Text("Salvar"),
                                      icon: const Icon(Icons.save)
                                    )
                                  ]
                                )
                              );
                            },
                            label: const Text("Trocar Senha"),
                            icon: const Icon(Icons.edit) 
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            label: const Text("Excluir minha conta"),
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  title: Text("Tem certeza?", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                  content: Text("Apagar sua conta resultará em exclusão de todas as suas interações, isto é uma ação irreversível, deseja prosseguir?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            this.showLoader();
                                            this._controller.deleteMyAccount().then((_) {
                                              final CurrentUserModel currentUser = Modular.get<CurrentUserModel>();
                                              currentUser.logout();
                                              SharedPreferences.getInstance().then((sp) {
                                                sp.remove("accessToken");
                                                sp.remove("refreshToken");
                                                final HubConnection hubConnection = Modular.get<HubConnection>();
                                                hubConnection.stop();
                                                this.hideLoader();
                                                Modular.to.navigate("/");
                                              });
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(10)
                                          ),
                                          label: const Text("Sim"),
                                          icon: const Icon(Icons.check)
                                        ),
                                        const SizedBox(width: 10,),
                                        ElevatedButton.icon(
                                          onPressed: Modular.to.pop,
                                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                                          label: const Text("Não"),
                                          icon: const Icon(Icons.cancel)
                                        )
                                      ]
                                    )
                                  ]
                                )
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  title: Text("Tem certeza?", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                  content: Text("Deseja realmente sair da aplicação? Você será redirecionado a tela de login", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            final CurrentUserModel currentUser = Modular.get<CurrentUserModel>();
                                            currentUser.logout();
                                            SharedPreferences.getInstance().then((sp) {
                                              sp.remove("accessToken");
                                              sp.remove("refreshToken");
                                              final HubConnection hubConnection = Modular.get<HubConnection>();
                                              hubConnection.stop();
                                              this.hideLoader();
                                              Modular.to.navigate("/login");
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(10)
                                          ),
                                          label: const Text("Sim"),
                                          icon: const Icon(Icons.check)
                                        ),
                                        const SizedBox(width: 10,),
                                        ElevatedButton.icon(
                                          onPressed: Modular.to.pop,
                                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                                          label: const Text("Não"),
                                          icon: const Icon(Icons.cancel)
                                        )
                                      ]
                                    )
                                  ]
                                )
                              );
                            },
                            label: const Text("Sair"),
                            icon: const Icon(Icons.logout) 
                          ),
                        ]
                      );
                    }
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