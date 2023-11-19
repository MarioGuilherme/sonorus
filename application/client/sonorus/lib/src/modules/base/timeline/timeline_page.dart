import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/modules/base/timeline/timeline_controller.dart";
import "package:sonorus/src/modules/base/timeline/widgets/comment.dart";
import "package:sonorus/src/modules/base/timeline/widgets/post.dart";
import "package:sonorus/src/modules/base/timeline/widgets/random_post_shimmer.dart";

class TimelinePage extends StatefulWidget {
  const TimelinePage({ super.key });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> with Messages, CustomShimmer {
  final ScrollController _scrollController = ScrollController();
  CarouselController buttonCarouselController = CarouselController();
  final TimelineController _controller = Modular.get<TimelineController>();
  late final ReactionDisposer _statusReactionDisposer;
  final _messageEC = TextEditingController();
  int _offset = 0;

  @override
  void initState() {
    this._controller.getFirstEightPosts(contentByPreference: this._controller.contentByPreference);
    this._scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          this._offset += 8;
        });
        this._controller.getMoreEightPosts(this._offset, contentByPreference: this._controller.contentByPreference);
      }
    });
    this._statusReactionDisposer = reaction((_) => this._controller.timelineStatus, (status) {
      switch (status) {
        case TimelineStateStatus.initial:
        case TimelineStateStatus.loadingPosts:
        case TimelineStateStatus.loadingMorePosts:
        case TimelineStateStatus.loadingComments:
        case TimelineStateStatus.savingComment:
        case TimelineStateStatus.loadedPosts:
        case TimelineStateStatus.loadedMorePosts:
        case TimelineStateStatus.loadedComments:
        case TimelineStateStatus.savedComment: break;
        case TimelineStateStatus.errorLoadComments:
        case TimelineStateStatus.errorSaveComment:
        case TimelineStateStatus.errorPosts:
          this.showMessage("Ops", this._controller.errorMessage ?? "Erro não mapeado");
          break;
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

  void onLoadComments(int postId) {
    this._controller.loadCommentsByPostId(postId);
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                height: this.context.screenHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFF404048),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)
                  )
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: 4,
                      width: 75,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(196, 196, 196, 1),
                        borderRadius: BorderRadius.circular(32)
                      )
                    ),
                    const SizedBox(height: 7.5),
                    Text(
                      "Comentários",
                      style: context.textStyles.textSemiBold.copyWith(color: Colors.white)
                    ),
                    const Divider(color: Colors.white),
                    Observer(
                      builder: (_) {
                        if (this._controller.timelineStatus == TimelineStateStatus.loadingComments)
                          return ListView(
                            shrinkWrap: true,
                            children: this.createRandomShimmers(() => const RandomPostShimmer())
                          );
                        if (this._controller.commentsOfOpenedPost.isEmpty)
                          return Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Nenhum comentário",
                                    style: context.textStyles.textSemiBold.copyWith(
                                      fontSize: 18.sp,
                                      color: Colors.white
                                    )
                                  ),
                                  Text(
                                    "Seje o primeiro!",
                                    style: context.textStyles.textMedium.copyWith(
                                      fontSize: 14.sp,
                                      color: Colors.white
                                    )
                                  )
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
                              comment: this._controller.commentsOfOpenedPost[i],
                              postId: postId,
                              onLikeComment: this._controller.likeCommentById,
                              onDelete: () {
                                this._controller.deleteComment(postId, this._controller.commentsOfOpenedPost[i].commentId).then((value) {
                                  setState(() {
                                    
                                  });
                                });
                              },
                              onUpdate: this._controller.updateComment
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
                        controller: this._messageEC,
                        textInputAction: TextInputAction.send,
                        style: context.textStyles.textRegular.copyWith(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Deixe um comentário",
                          hintStyle: context.textStyles.textMedium.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp
                          ),
                          contentPadding: const EdgeInsets.only(left: 16)
                        )
                      )
                    )
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent,
                        child: IconButton.outlined(
                          icon: Icon(Icons.send, color: context.colors.primary, size: 28),
                          onPressed: () {
                            final String newComment = this._messageEC.text.trim();
                            if (newComment.isEmpty) return;
                            this._controller.saveComment(postId, this._messageEC.text).then((value) {
                              FocusScope.of(context).unfocus();
                              this._messageEC.clear();
                            });
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
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => this._controller.getFirstEightPosts(contentByPreference: this._controller.contentByPreference),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Filtrar publicações: ",
                  style: context.textStyles.textSemiBold.copyWith(color: Colors.white, fontSize: 12.sp)
                ),
                DropdownButton<bool>(
                  icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                  isDense: true,
                  value: this._controller.contentByPreference,
                  style: context.textStyles.textMedium.copyWith(fontSize: 12.sp, color: context.colors.primary),
                  underline: Container(),
                  onChanged: (bool? value) {
                    this._controller.updateContentByPreference(value ?? false);
                    setState(() {
                      this._offset = 0;
                    });
                    this._controller.getFirstEightPosts(contentByPreference: this._controller.contentByPreference);
                  },
                  items: const [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text("Meus interesses")
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text("Todos")
                    )
                  ]
                )
              ]
            )
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Observer(
              builder: (_) {
                if (this._controller.timelineStatus == TimelineStateStatus.loadingPosts)
                  return ListView(
                    shrinkWrap: true,
                    children: this.createRandomShimmers(() => const RandomPostShimmer())
                  );
                if (this._controller.posts.isEmpty)
                  return Center(
                    child: Text(
                      "Nenhuma publicação encontrada",
                      style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 14.sp)
                    )
                  );
                return ListView.builder(
                  controller: this._scrollController,
                  shrinkWrap: true,
                  itemCount: this._controller.posts.length,
                  itemBuilder: (_, i) {
                    if (this._controller.timelineStatus == TimelineStateStatus.loadingMorePosts && this._controller.posts.length == i + 1)
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Post(
                              post: this._controller.posts[i],
                              commentsOfOpenedPost: this._controller.commentsOfOpenedPost,
                              onLike: this._controller.likePostById,
                              onLikeComment: this._controller.likeCommentById,
                              showCommentsByPostId: this.onLoadComments,
                              onComment: this._controller.saveComment,
                              onDelete: this._controller.deletePost
                            )
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: RandomPostShimmer()
                          )
                        ]
                      );

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Post(
                        post: this._controller.posts[i],
                        commentsOfOpenedPost: this._controller.commentsOfOpenedPost,
                        onLike: this._controller.likePostById,
                        onLikeComment: this._controller.likeCommentById,
                        showCommentsByPostId: this.onLoadComments,
                        onComment: this._controller.saveComment,
                        onDelete: this._controller.deletePost
                      )
                    );
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