import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/extensions/time_ago_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/current_user_model.dart";

class Comment extends StatefulWidget {
  final CommentModel comment;
  final int postId;
  final Future<int> Function(int commentId) onLikeComment;
  final void Function() onDelete;
  final Future<void> Function(int commentId, String updatedContent) onUpdate;

  const Comment({
    super.key,
    required this.comment,
    required this.postId,
    required this.onLikeComment,
    required this.onDelete,
    required this.onUpdate
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> with Messages, Loader {
  final TextEditingController _newCommentEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int currentUserId = Modular.get<CurrentUserModel>().userId!;
    this._newCommentEC.text = this.widget.comment.content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: this.widget.comment.author!.userId != currentUserId
          ? null
          : () {
            showDialog(
              context: this.context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                actionsAlignment: MainAxisAlignment.center,
                content: Text("O que deseja fazer com este comentário?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
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
                              content: Text("Deseja mesmo apagar este comentário?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        Modular.to.pop();
                                        this.showLoader();
                                        this.widget.onDelete();
                                        this.hideLoader();
                                        this.showMessage("Comentário apagado", "Seu comentário foi apagado com sucesso");
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
                          Modular.to.pop();
                          showDialog(
                            context: this.context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              actionsAlignment: MainAxisAlignment.center,
                              content: TextFormField(
                                cursorColor: Colors.white,
                                controller: this._newCommentEC,
                                textInputAction: TextInputAction.send,
                                style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Edite seu comentário",
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
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final String newContent = this._newCommentEC.text;

                                    if (newContent.trim().isEmpty) return;

                                    Modular.to.pop();
                                    this.showLoader();
                                    await this.widget.onUpdate(this.widget.comment.commentId, this._newCommentEC.text);
                                    this.hideLoader();
                                    this.showMessage("Comentário atualizado", "Seu comentário foi atualizado com sucesso");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(10)
                                  ),
                                  label: const Text("Salvar"),
                                  icon: const Icon(Icons.check)
                                )
                              ]
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
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                border: Border.all(
                  color: context.colors.primary,
                  width: 2
                )
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.network(
                  this.widget.comment.author!.picture,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover
                )
              )
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      this.widget.comment.author!.nickname,
                      style: context.textStyles.textExtraBold.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp
                      ),
                    ),
                    Text(
                      this.widget.comment.content,
                      style: context.textStyles.textRegular.copyWith(
                        color: Colors.white,
                        fontSize: 13.sp
                      )
                    ),
                    Text(
                      this.widget.comment.commentedAt.timeAgo,
                      style: context.textStyles.textLight.copyWith(
                        color: Colors.white,
                        fontSize: 8.sp
                      )
                    )
                  ]
                )
              )
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    final int totalLikes = await this.widget.onLikeComment(this.widget.comment.commentId);
                    setState(() {
                      this.widget.comment.totalLikes = totalLikes;
                      this.widget.comment.isLikedByMe = !this.widget.comment.isLikedByMe;
                    });
                  },
                  child: Ink(
                    child: Icon(
                      this.widget.comment.isLikedByMe
                        ? Icons.favorite
                        : Icons.favorite_border,
                      color: context.colors.primary
                    )
                  )
                ),
                const SizedBox(width: 5),
                Text(
                  "${this.widget.comment.totalLikes}",
                  style: context.textStyles.textExtraBold.copyWith(color: Colors.white)
                )
              ]
            )
          ]
        ),
      ),
    );
  }
}