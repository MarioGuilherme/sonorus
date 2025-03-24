import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";

import "package:sonorus/src/core/extensions/time_ago_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/modal_form.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/view_models/comment_view_model.dart";

class Comment extends StatefulWidget {
  final int postId;
  final CommentViewModel comment;
  final Future<int> Function(int postId, int commentId) onPressedLikeButton;
  final Future<void> Function(int postId, int commentId) onConfirmDelete;
  final Future<void> Function(int postId, int commentId, String updatedContent) onConfirmUpdate;

  const Comment({
    super.key,
    required this.postId,
    required this.comment,
    required this.onPressedLikeButton,
    required this.onConfirmDelete,
    required this.onConfirmUpdate
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> with Messages, Loader, ModalForm {
  final TextEditingController _newCommentEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this._newCommentEC.text = this.widget.comment.content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: this.widget.comment.author!.userId != Modular.get<AuthenticatedUser>().userId ? null : () {
          this.showMessageWithActions(
            title: "Opções do comentário",
            message: "O que deseja fazer com este comentário?",
            buttonsInRow: true,
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                label: const Text("Excluir"),
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Modular.to.pop();
                  this.showQuestionMessage(
                    title: "Tem certeza?",
                    message: "Deseja mesmo apagar este comentário?",
                    onConfirmButtonPressed: () async => this.widget.onConfirmDelete(this.widget.postId, this.widget.comment.commentId)
                  );
                }
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                label: const Text("Editar"),
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Modular.to.pop();
                  this.showModalForm(
                    title: "Editando comentário",
                    content: TextFormField(
                      controller: this._newCommentEC,
                      textInputAction: TextInputAction.send,
                      style: context.textStyles.textRegular,
                      decoration: InputDecoration(
                        hintText: "Novo comentário",
                        fillColor: const Color.fromRGBO(85, 85, 87, 1),
                        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        hintStyle: context.textStyles.textMedium.withFontSize(14),
                        contentPadding: const EdgeInsets.only(left: 16)
                      )
                    ),
                    actions: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                        label: const Text("Salvar"),
                        icon: const Icon(Icons.check),
                        onPressed: () async {
                          final String content = this._newCommentEC.text;
                          if (content.trim().isEmpty) return;
                          await this.widget.onConfirmUpdate(this.widget.postId, this.widget.comment.commentId, content);
                        }
                      )
                    ]
                  );
                }
              )
            ]
          );
        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(200), border: Border.all(color: context.colors.primary, width: 2)),
              child: ClipRRect(borderRadius: BorderRadius.circular(200), child: Image.network(this.widget.comment.author!.picture, width: 50, height: 50, fit: BoxFit.cover))
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(this.widget.comment.author!.nickname, style: context.textStyles.textExtraBold.withFontSize(14)),
                    Text(this.widget.comment.content, style: context.textStyles.textRegular.withFontSize(13)),
                    Text(this.widget.comment.commentedAt.timeAgo, style: context.textStyles.textLight.withFontSize(8))
                  ]
                )
              )
            ),
            Row(
              children: [
                InkWell(
                  child: Ink(child: Icon(this.widget.comment.isLikedByMe ? Icons.favorite : Icons.favorite_border, color: context.colors.primary)),
                  onTap: () async {
                    setState(() {
                      this.widget.comment.isLikedByMe = !this.widget.comment.isLikedByMe;
                      this.widget.comment.totalLikes = this.widget.comment.totalLikes + (this.widget.comment.isLikedByMe ? 1 : -1);
                    });
                    final int totalLikes = await this.widget.onPressedLikeButton(this.widget.postId, this.widget.comment.commentId);
                    if (totalLikes == -1)
                      setState(() {                
                        this.widget.comment.isLikedByMe = !this.widget.comment.isLikedByMe;
                        this.widget.comment.totalLikes = this.widget.comment.totalLikes + (this.widget.comment.isLikedByMe ? 1 : -1);
                      });
                  }
                ),
                const SizedBox(width: 5),
                Text("${this.widget.comment.totalLikes}", style: context.textStyles.textExtraBold)
              ]
            )
          ]
        )
      )
    );
  }
}