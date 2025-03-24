import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/modal_form.dart";
import "package:sonorus/src/core/ui/widgets/interest_tag.dart";
import "package:sonorus/src/dtos/view_models/post_view_model.dart";
import "package:sonorus/src/modules/navigation/post/post_controller.dart";
import "package:sonorus/src/modules/navigation/post/widgets/comments_modal_bottom_sheet.dart";
import "package:sonorus/src/modules/navigation/post/widgets/post.dart";
import "package:sonorus/src/modules/navigation/post/widgets/post_form.dart";
import "package:sonorus/src/modules/navigation/post/widgets/random_post_shimmer.dart";

class PostPage extends StatefulWidget {
  const PostPage({ super.key });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with Messages, Loader, ModalForm, CustomShimmer {
  final PostController _controller = Modular.get<PostController>();
  final ScrollController _scrollController = ScrollController();
  final CarouselController buttonCarouselController = CarouselController();
  final TextEditingController _contentEC = TextEditingController();
  final TextEditingController _tablatureEC = TextEditingController();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getPagedPosts();
    this._scrollController.addListener(() {
      if (this._scrollController.position.pixels == this._scrollController.position.maxScrollExtent) {
        this._controller.setOffset(null);
        this._controller.getPagedPosts();
      }
    });
    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) {
      switch (status) {
        case PostPageStatus.initial:
        case PostPageStatus.loadingPosts:
        case PostPageStatus.loadingComments:
        case PostPageStatus.loadedPosts:
        case PostPageStatus.loadedComments:
          break;
        case PostPageStatus.deletingComment:
        case PostPageStatus.deletingPost:
        case PostPageStatus.updatingComment:
          Modular.to.pop();
          this.showLoader();
          break;
        case PostPageStatus.savingPost:
        case PostPageStatus.loadingAllTags:
        case PostPageStatus.creatingComment:
          this.showLoader();
          break;
        case PostPageStatus.createdComment:
        case PostPageStatus.deletedComment:
          this.hideLoader();
          break;
        case PostPageStatus.deletedPost:
          this.hideLoader();
          this.showSuccessMessage("Sua publicação foi apagada com sucesso!");
          this._controller.resetOffset();
          this._controller.getPagedPosts();
          break;
        case PostPageStatus.updatedComment:
          this.hideLoader();
          this.showSuccessMessage("Seu comentário foi atualizado com sucesso!");
          break;
        case PostPageStatus.loadedAllTags:
          this.hideLoader();
          this.showModalForm(
            title: "Adicionar tags",
            content: Padding(
              padding: const EdgeInsets.all(12),
              child: Observer(
                builder: (_) => Wrap(
                  children: this._controller.allTags.where((t) => !this._controller.selectedTags.any((st) => t.interestId == st.interestId)).map((nst) => InterestTag(
                    interestKey: nst.key!,
                    onPressed: () => this._controller.associateTag(nst)
                  )).toList()
                )
              )
            )
          );
          break;
        case PostPageStatus.savedPost:
          this.switchShowForm(showForm: false);
          this._controller.resetOffset();
          this._controller.getPagedPosts();
          this.hideLoader();
          this.showSuccessMessage("Sua publicação foi salva com sucesso!");
          break;
        case PostPageStatus.error:
          this.hideLoader();
          this.showErrorMessage(this._controller.error);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    this._statusReactionDisposer();
    super.dispose();
  }

  void bindForm(PostViewModel postViewModel) {
    this.switchShowForm(showForm: true);
    this._controller.setPostId(postViewModel.postId);
    this._tablatureEC.text = postViewModel.tablature ?? "";
    this._contentEC.text = postViewModel.content ?? "";
    this._controller.addOldMedias(postViewModel.medias);
    this._controller.addSelectedTags(postViewModel.interests);
  }

  void clearForm() {
    this._controller.setPostId(null);
    this._contentEC.clear();
    this._tablatureEC.clear();
    this._controller.selectedTags.clear();
    this._controller.newMedias.clear();
    this._controller.oldMedias.clear();
    this._controller.oldMediasToRemove.clear();
  }

  void switchShowForm({ bool? showForm }) {
    this.clearForm();
    this._controller.toggleShowForm(showForm);
  }

  void loadsCommentsByPostId(int postId) {
    this._controller.loadCommentsByPostId(postId);
    showModalBottomSheet(
      useSafeArea: true,
      context: this.context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsModalBottomSheet(postId: postId)
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        this._controller.resetOffset();
        this._controller.getPagedPosts();
      },
      child: Column(
        children: [
          Observer(builder: (_) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                this._controller.showForm
                  ? Expanded(child: Text("${this._controller.postId != null ? "EDITANDO" : "CRIANDO"} PUBLICAÇÃO", style: context.textStyles.textBold.withFontSize(18), textAlign: TextAlign.center))
                  : Expanded(
                    child: Row(
                      children: [
                        Text("Filtrar publicações: ", textAlign: TextAlign.center, style: context.textStyles.textSemiBold.withFontSize(14)),
                        SizedBox(width: 7.5),
                        DropdownButton<bool>(
                          icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                          isDense: true,
                          value: this._controller.contentByPreference,
                          style: context.textStyles.textMedium.copyWith(fontSize: 12.sp, color: context.colors.primary),
                          underline: Container(),
                          onChanged: (value) {
                            this._controller.toggleContentByPreference(value!);
                            this._controller.resetOffset();
                            this._controller.getPagedPosts();
                          },
                          items: const [
                            DropdownMenuItem<bool>(value: true, child: Text("Meus interesses")),
                            DropdownMenuItem<bool>(value: false, child: Text("Todos"))
                          ]
                        )
                      ]
                    )
                  ),
                SizedBox(width: 15),
                IconButton.filled(
                  icon: Icon(this._controller.showForm ? Icons.list_alt : Icons.add),
                  onPressed: () {
                    this.clearForm();
                    this._controller.toggleShowForm(null);
                  }
                )
              ]
            )
          )),
          const SizedBox(height: 10),
          Expanded(
            child: Observer(
              builder: (_) {
                if (this._controller.showForm)
                  return PostForm(
                    contentEC: this._contentEC,
                    tablatureEC: this._tablatureEC,
                    allTags: [...this._controller.allTags],
                    selectedTags: [...this._controller.selectedTags],
                    disassociateTag: this._controller.disassociateTag,
                    newMedias: [...this._controller.newMedias],
                    oldMedias: [...this._controller.oldMedias],
                    associateTag: this._controller.addNewMedias,
                    removeNewMedia: this._controller.removeNewMedia,
                    removeOldMedia: this._controller.removeOldMedia,
                    showModalWithTags: this._controller.showModalWithTags,
                    onSubmitValid: () async {
                      if ([this._controller.newMedias, this._controller.oldMedias].isEmpty) {
                        this.showErrorMessage("É necessário ter em anexo no mínimo uma foto ou vídeo!");
                        return;
                      }
                      if (this._contentEC.text.isEmpty && [this._controller.newMedias, this._controller.oldMedias].isEmpty) {
                        this.showErrorMessage("É necessário informar algum conteúdo escrito ou anexar no mínimo uma imagem ou vídeo!");
                        return;
                      }
                      if (this._controller.selectedTags.length < 3) {
                        this.showErrorMessage("É necessário selecionar no mínimo três tags para a publicação!");
                        return;
                      }
                      await this._controller.savePost(this._contentEC.text, this._tablatureEC.text);
                    }
                  );

                if (this._controller.status == PostPageStatus.loadingPosts && this._controller.posts.isEmpty)
                  return ListView(shrinkWrap: true, children: this.createRandomShimmers(() => const RandomPostShimmer()));
      
                if (this._controller.posts.isEmpty)
                  return Center(child: Text("Nenhuma publicação encontrada", style: context.textStyles.textMedium.withFontSize(14)));
      
                return ListView.builder(
                  controller: this._scrollController,
                  shrinkWrap: true,
                  itemCount: this._controller.posts.length,
                  itemBuilder: (_, i) {
                    final Padding postWithPadding = Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Post(
                      post: this._controller.posts[i],
                      onPressedLikeButton: this._controller.likePostById,
                      onPressedCommentsButton: this.loadsCommentsByPostId,
                      onConfirmedDelete: this._controller.deletePost,
                      onPressedEditButton: (postViewModel) {
                        Modular.to.pop();
                        this.bindForm(postViewModel);
                      }
                    ));
                    if (this._controller.status == PostPageStatus.loadingPosts && this._controller.posts.length == i + 1)
                      return Column(
                        children: [
                          postWithPadding,
                          const Padding(padding: EdgeInsets.only(bottom: 8), child: RandomPostShimmer())
                        ]
                      );
      
                    return postWithPadding;
                  }
                );
              }
            )
          )
        ]
      )
    );
  }
}