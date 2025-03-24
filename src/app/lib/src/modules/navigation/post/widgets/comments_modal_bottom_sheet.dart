import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";

import "package:sonorus/src/core/extensions/size_extensions.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/modules/navigation/post/post_controller.dart";
import "package:sonorus/src/modules/navigation/post/widgets/comment.dart";
import "package:sonorus/src/modules/navigation/post/widgets/random_comment_shimmer.dart";

class CommentsModalBottomSheet extends StatefulWidget {
  final int postId;

  const CommentsModalBottomSheet({ required this.postId, super.key });

  @override
  State<CommentsModalBottomSheet> createState() => _CommentsModalBottomSheetState();
}

class _CommentsModalBottomSheetState extends State<CommentsModalBottomSheet> with CustomShimmer {
  final PostController _controller = Modular.get<PostController>();
  final TextEditingController _commentEC = TextEditingController();

  @override
  Widget build(BuildContext context) => Padding(
    padding: MediaQuery.of(context).viewInsets,
    child: Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            height: context.screenHeight,
            decoration: const BoxDecoration(
              color: Color(0xFF404048),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 4,
                  width: 75,
                  decoration: BoxDecoration(color: const Color.fromRGBO(196, 196, 196, 1), borderRadius: BorderRadius.circular(32))
                ),
                const SizedBox(height: 7.5),
                Text("Comentários", style: context.textStyles.textSemiBold),
                const Divider(color: Colors.white),
                Observer(
                  builder: (_) {
                    if (this._controller.status == PostPageStatus.error)
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ops!", style: context.textStyles.textSemiBold.withFontSize(18)),
                              Text("Ocorreu um erro ao buscar os comentários!", style: context.textStyles.textMedium.withFontSize(14))
                            ]
                          )
                        )
                      );

                    if (this._controller.status == PostPageStatus.loadingComments)
                      return ListView(
                        shrinkWrap: true,
                        children: this.createRandomShimmers(() => const RandomCommentShimmer())
                      );

                    if (this._controller.commentsOfOpenedPost.isEmpty)
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nenhum comentário", style: context.textStyles.textSemiBold.withFontSize(18)),
                              Text("Seje o primeiro!", style: context.textStyles.textMedium.withFontSize(14))
                            ]
                          )
                        )
                      );

                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: this._controller.commentsOfOpenedPost.length,
                        itemBuilder: (_, i) => Comment(
                          postId: this.widget.postId,
                          comment: this._controller.commentsOfOpenedPost[i],
                          onPressedLikeButton: this._controller.likeCommentById,
                          onConfirmDelete: this._controller.deleteComment,
                          onConfirmUpdate: this._controller.updateComment
                        )
                      )
                    );
                  }
                )
              ]
            )
          )
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF373739),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: TextFormField(
                    controller: this._commentEC,
                    style: context.textStyles.textRegular,
                    decoration: InputDecoration(
                      hintText: "Deixe um comentário",
                      hintStyle: context.textStyles.textMedium.withFontSize(14),
                      contentPadding: const EdgeInsets.only(left: 16)
                    )
                  )
                )
              ),
              const SizedBox(width: 5),
              SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Material(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.transparent,
                    child: IconButton.outlined(
                      icon: Icon(Icons.send, color: context.colors.primary, size: 28),
                      onPressed: () async {
                        final String content = this._commentEC.text.trim();
                        if (content.isEmpty) return;
                        await this._controller.createComment(this.widget.postId, content);
                        this._commentEC.clear();
                      }
                    )
                  )
                )
              )
            ]
          )
        )
      ]
    )
  );
}