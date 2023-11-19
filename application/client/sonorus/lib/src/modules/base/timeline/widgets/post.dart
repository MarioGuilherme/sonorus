import "dart:io";

import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:image_picker/image_picker.dart";
import "package:sonorus/src/core/extensions/time_ago_extension.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/utils/routes.dart";
import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/post_with_author_model.dart";
import "package:sonorus/src/modules/base/creation/creation_controller.dart";
import "package:sonorus/src/modules/base/creation/widgets/tag_post.dart";
import "package:sonorus/src/modules/base/timeline/timeline_controller.dart";
import "package:sonorus/src/modules/base/timeline/widgets/hash_tag.dart";
import "package:sonorus/src/modules/base/timeline/widgets/video_media_post.dart";
import "package:sonorus/src/modules/base/widgets/picture_user.dart";
import "package:validatorless/validatorless.dart";

class Post extends StatefulWidget {
  final PostWithAuthorModel post;
  final List<CommentModel> commentsOfOpenedPost;
  final Future<int> Function(int postId) onLike;
  final Future<int> Function(int commentId) onLikeComment;
  final void Function(int postId) showCommentsByPostId;
  final Future<void> Function(int postId, String content) onComment;
  final Future<void> Function(int postId) onDelete;

  const Post({
    super.key,
    required this.post,
    required this.commentsOfOpenedPost,
    required this.onLike,
    required this.showCommentsByPostId,
    required this.onLikeComment,
    required this.onComment,
    required this.onDelete
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with Messages, Loader {
  final ImagePicker _picker = ImagePicker();
  final TimelineController _timelineController = Modular.get<TimelineController>();
  final CreationController _creationController = Modular.get<CreationController>();
  final TextEditingController _postContentEC = TextEditingController();
  final TextEditingController _tablatureEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Color(0xFF404048)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final bool isPostedByMe = Modular.get<CurrentUserModel>().userId == this.widget.post.author.userId;
                            if (isPostedByMe)
                              Modular.to.pushNamed(Routes.userPage);
                            Modular.to.pushNamed(
                              "/chat/",
                              arguments: [
                                "",
                                ChatModel(
                                  friend: this.widget.post.author,
                                  messages: []
                                )
                              ]
                            );
                          },
                          child: PictureUser(
                            picture: Image.network(
                              this.widget.post.author.picture,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover
                            )
                          )
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: Ink(
                                child: InkWell(
                                  onTap: () {
                                    final bool isPostedByMe = Modular.get<CurrentUserModel>().userId == this.widget.post.author.userId;
                                    if (isPostedByMe)
                                      Modular.to.pushNamed(Routes.userPage, arguments: this.widget.post.author.userId);
                                    Modular.to.pushNamed(
                                      "/chat/",
                                      arguments: [
                                        "",
                                        ChatModel(
                                          friend: this.widget.post.author,
                                          messages: []
                                        )
                                      ]
                                    );
                                  },
                                  child: Text(
                                    this.widget.post.author.nickname,
                                    style: context.textStyles.textBold.copyWith(color: Colors.white, fontSize: 14.sp)
                                  )
                                )
                              )
                            ),
                            Text(
                              this.widget.post.postedAt.timeAgo,
                              textAlign: TextAlign.end,
                              style: context.textStyles.textThin.copyWith(color: Colors.white, fontSize: 10.sp)
                            )
                          ]
                        ),
                        if (Modular.get<CurrentUserModel>().userId == this.widget.post.author.userId)
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Ink(
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: this.context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            actionsAlignment: MainAxisAlignment.center,
                                            content: Text("O que deseja fazer com esta publicação?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                            actions: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      Modular.to.pop();
                                                      showDialog(
                                                        context: this.context,
                                                        builder: (context) => AlertDialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                          title: Text("Tem certeza?", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                                          content: Text("Deseja mesmo apagar esta publicação?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                                          actionsAlignment: MainAxisAlignment.center,
                                                          actions: [
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                ElevatedButton.icon(
                                                                  onPressed: () async {
                                                                    Modular.to.pop();
                                                                    this.showLoader();
                                                                    await this.widget.onDelete(this.widget.post.postId);
                                                                    this.hideLoader();
                                                                    this.showMessage("Publicação apagada", "Sua publicação foi apagada com sucesso");
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
                                                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                                                    label: const Text("Excluir"),
                                                    icon: const Icon(Icons.delete)
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      this._creationController.clearPostOldMedias();
                                                      this._creationController.clearPostnewMedias();
                                                      this._creationController.setPostldMMedias(this.widget.post.medias.map((media) => XFile(media.path)).toList());
                                                      this._creationController.clearSelectedTags();
                                                      this._creationController.setOldTags(this.widget.post.interests);

                                                      this._postContentEC.text = this.widget.post.content ?? "";
                                                      this._tablatureEC.text = this.widget.post.tablature ?? "";
                                                      showDialog(
                                                        context: this.context,
                                                        builder: (context) => Material(
                                                          color: Colors.transparent,
                                                          child: Container(
                                                            margin: const EdgeInsets.all(10),
                                                            padding: const EdgeInsets.all(10),
                                                            color: context.colors.secondary,
                                                            child: Observer(
                                                              builder: (context) {
                                                                return Form(
                                                                  key: this._formKey,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                    children: [
                                                                      SizedBox(
                                                                        child: ElevatedButton(
                                                                          onPressed: () async {
                                                                            Modular.to.pop();
                                                                          },
                                                                          child: const Icon(Icons.close)
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Editando publicação",
                                                                              textAlign: TextAlign.center,
                                                                              style: context.textStyles.textBold.copyWith(fontSize: 22.sp)
                                                                            ),
                                                                            const SizedBox(height: 10),
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
                                                                                  ...(this._creationController.tagsSelectedToPost.map(
                                                                                    (interest) => Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(12),
                                                                                        child: Material(
                                                                                          color: Colors.white,
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              this._creationController.removeTagSelected(interest);
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
                                                                                                              (t) => !this._creationController.tagsSelectedToPost.any((element) => t.interestId == element.interestId)
                                                                                                            ).map((tag) => Padding(
                                                                                                                padding: const EdgeInsets.symmetric(vertical: 2),
                                                                                                                child: TagPost(
                                                                                                                  tag: tag.key,
                                                                                                                  isSelected: this._creationController.tagsSelectedToPost.any((t) => t.interestId == tag.interestId),
                                                                                                                  onPressed: () {
                                                                                                                    setState(() {
                                                                                                                      if (this._creationController.tagsSelectedToPost.any((t) => t.interestId == tag.interestId))
                                                                                                                        this._creationController.removeTagSelected(tag);
                                                                                                                      else
                                                                                                                        this._creationController.addTagSelected(tag);
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
                                                                            (this._creationController.postOldmedias.length + this._creationController.postnewmedias.length == 0)
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
                                                                              : Expanded(
                                                                                child: SingleChildScrollView(
                                                                                  child: GridView(
                                                                                      shrinkWrap: true,
                                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                        crossAxisCount: 3,
                                                                                        mainAxisSpacing: 10
                                                                                      ),
                                                                                      children: [...this._creationController.postOldmedias, ...this._creationController.postnewmedias].map(
                                                                                        (media) => Stack(
                                                                                          alignment: Alignment.center,
                                                                                          children: [
                                                                                            media.path.split(".")[5] == "mp4"
                                                                                              ? Padding(
                                                                                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                                                                                child: VideoMediaPost(media.path),
                                                                                              )
                                                                                              : media.path[0] == "/"
                                                                                                ? Image.file(
                                                                                                    File(media.path),
                                                                                                    fit: BoxFit.contain,
                                                                                                  )
                                                                                                : Image.network(
                                                                                                    media.path,
                                                                                                    fit: BoxFit.contain,
                                                                                                  ),
                                                                                            Align(
                                                                                              alignment: Alignment.topRight,
                                                                                              child: IconButton(
                                                                                                splashRadius: 1,
                                                                                                onPressed: () {
                                                                                                  setState(() {
                                                                                                    this._creationController.removeFrom2list(media);
                                                                                                  });
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
                                                                                ),
                                                                              ),
                                                                            if (this._creationController.postOldmedias.length + this._creationController.postnewmedias.length < 5) ...[
                                                                              const SizedBox(height: 10),
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  this._picker.pickMultipleMedia().then((medias) {
                                                                                    if (this._creationController.postOldmedias.length + this._creationController.postnewmedias.length + medias.length > 5)
                                                                                      this._creationController.addNewPostMedias(medias.sublist(0, (5 - (this._creationController.postOldmedias.length + this._creationController.postnewmedias.length))));
                                                                                    else
                                                                                      this._creationController.addNewPostMedias(medias);
                                                                                  });
                                                                                },
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                  child: Text("Anexar fotos ou vídeos"),
                                                                                )
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
                                                                                                    controller: this._tablatureEC,
                                                                                                    style: context.textStyles.textMediumMono.copyWith(color: Colors.black),
                                                                                                    validator: Validatorless.max(255, "A tablatura pode ter no máximo 1000 caracteres."),
                                                                                                    decoration: const InputDecoration(isDense: true),
                                                                                                    onChanged: (value) {
                                                                                                      value = value.replaceAll(RegExp("[eBGDAEBF#| ]"), "");
                                                                                                      final stringAcronyms = ["e", "B", "G", "D", "A", "E", "B", "F#"];
                                                                                                      final aa = value.split("\n").sublist(0, value.split("\n").length > 8 ? 8 : value.split("\n").length);
                                                                                                      // String maisLonga = "";

                                                                                                      // for (String str in aa) {
                                                                                                      //   if (str.length > maisLonga.length) {
                                                                                                      //     maisLonga = str;
                                                                                                      //   }
                                                                                                      // }

                                                                                                      for (var i = 0; i < aa.length; i++) {
                                                                                                        final remain = aa[i];//.padRight(maisLonga.length, "-");
                                                                                                        final ac = stringAcronyms[i].padRight(3, " ");
                                                                                                        aa[i] = "$ac| $remain";
                                                                                                      }
                                                                                                      final result = aa.join(" |\n");
                                                                                                      final previousSelection = _tablatureEC.selection;
                                                                                                      this._tablatureEC.text = result;
                                                                                                      this._tablatureEC.selection = previousSelection;
                                                                                                      // _tablatureEC.value = _tablatureEC.value.copyWith(
                                                                                                      //   text: result,
                                                                                                      //   selection: previousSelection,
                                                                                                      //   composing: TextRange.empty,
                                                                                                      // );
                                                                                                    }
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
                                                                              },
                                                                              label: const Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                child: Text("Tablatura"),
                                                                              )
                                                                            ),
                                                                            Text(
                                                                              "(Caso não queira anexar, deixe o campo em branco)",
                                                                              textAlign: TextAlign.center,
                                                                              style: context.textStyles.textMedium.copyWith(fontSize: 11.sp)
                                                                            )
                                                                          ],
                                                                        )
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey),
                                                                        onPressed: () async {
                                                                          final bool formValid = this._formKey.currentState?.validate() ?? false;
                                                        
                                                                          if (formValid) {
                                                                            showLoader();
                                                                            await this._creationController.updatePost(
                                                                              this.widget.post.postId,
                                                                              this._postContentEC.text,
                                                                              this._tablatureEC.text,
                                                                              this._creationController.tagsSelectedToPost.map((t) => t.interestId!).toList(),
                                                                              [...this._creationController.postOldmedias, ...this._creationController.postnewmedias].map((media) => XFile(media.path)).toList()
                                                                            ).then((_) {
                                                                              hideLoader();
                                                                              showDialog(
                                                                                barrierDismissible: true,
                                                                                context: this.context,
                                                                                builder: (context) => AlertDialog(
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                                  title: Text("Sucesso", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                                                                  content: Text("Publicação atualizada com sucesso", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                                                                  actionsAlignment: MainAxisAlignment.center,
                                                                                  actions: [
                                                                                    ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(20))
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        Modular.to.pop();
                                                                                        Modular.to.pop();
                                                                                        Modular.to.pop();
                                                                                        this._timelineController.getFirstEightPosts(contentByPreference: this._timelineController.contentByPreference);
                                                                                      },
                                                                                      child: Text("Ok", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                                                                                    )
                                                                                  ]
                                                                                )
                                                                              );
                                                                            });
                                                                          }
                                                                        },
                                                                        child: const Text("Atualizar")
                                                                      )
                                                                    ]
                                                                  )
                                                                );
                                                              }
                                                            )
                                                          )
                                                        )
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.all(10)
                                                    ),
                                                    label: const Text("Editar"),
                                                    icon: const Icon(Icons.edit)
                                                  )
                                                ]
                                              )
                                            ]
                                          )
                                        );
                                      },
                                      child: const Icon(
                                        Icons.more_horiz,
                                        color: Colors.white,
                                        size: 28
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                      ]
                    ),
                    if (this.widget.post.content != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              this.widget.post.content!,
                              style: context.textStyles.textRegular.copyWith(color: Colors.white, fontSize: 12.sp)
                            )
                          )
                        ]
                      )
                    ]
                  ]
                )
              ),
              if (this.widget.post.medias.isNotEmpty) ...[
                const SizedBox(height: 10),
                CarouselSlider.builder(
                  itemBuilder: (_, i, __) => this.widget.post.medias[i].isPicture
                    ? Image.network(
                        this.widget.post.medias[i].path,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null
                              )
                            )
                          );
                        }
                      )
                    : VideoMediaPost(this.widget.post.medias[i].path),
                  itemCount: this.widget.post.medias.length,
                  options: CarouselOptions(
                    height: 277,
                    viewportFraction: 1,
                    enableInfiniteScroll: false
                  )
                )
              ],
              Padding(
                padding: const EdgeInsets.all(5),
                child: Wrap(children: this.widget.post.interests.map((interest) => HashTag(interest.key)).toList()),
              )
            ]
          )
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            color: Color(0xFF16161F),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final int totalLikes = await this.widget.onLike(this.widget.post.postId);
                    setState(() {
                      this.widget.post.totalLikes = totalLikes;
                      this.widget.post.isLikedByMe = !this.widget.post.isLikedByMe;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 91, 100),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)))
                  ),
                  icon: Icon(
                    this.widget.post.isLikedByMe
                      ? Icons.favorite
                      : Icons.favorite_border,
                    color: context.colors.primary
                  ),
                  label: Text("${this.widget.post.totalLikes}", style: TextStyle(fontSize: 14.sp))
                )
              ),
              if (this.widget.post.tablature != null) ...[
                const SizedBox(width: 2.5),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      useSafeArea: true,
                      builder: (context) => WillPopScope(
                        onWillPop: () async {
                          await SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);
                          return true;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);
                                    Modular.to.pop();
                                  },
                                  child: const Icon(Icons.close)
                                )
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 8,
                                child: SingleChildScrollView( // <== talvez remover o scroll
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: FittedBox(
                                    child: Text(
                                      this.widget.post.tablature!,
                                      style:
                                      TextStyle(
                                        color: Colors.black,
                                        fontFamily: context.textStyles.monospaced
                                      )
                                    )
                                  )
                                )
                              )
                            ]
                          )
                        )
                      )
                    );
                    await SystemChrome.setPreferredOrientations([ DeviceOrientation.landscapeLeft ]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 91, 100),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.zero))
                  ),
                  child: Icon(
                    Icons.music_note,
                    size: 22.sp,
                    color: Colors.white
                  )
                )
              ],
              const SizedBox(width: 2.5),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => this.widget.showCommentsByPostId(this.widget.post.postId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 91, 100),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)))
                  ),
                  icon: Icon(Icons.forum, color: context.colors.primary),
                  label: Text(
                    this.widget.post.totalComments.toString(),
                    style: TextStyle(fontSize: 14.sp)
                  )
                )
              )
            ]
          )
        )
      ]
    );
  }
}