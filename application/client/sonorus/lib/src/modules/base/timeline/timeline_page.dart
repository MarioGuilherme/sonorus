import "dart:developer";
import "dart:math";

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
import "package:sonorus/src/modules/base/timeline/widgets/random_post_shimmer.dart";

import "package:sonorus/src/modules/base/timeline/timeline_controller.dart";
import "package:sonorus/src/modules/base/timeline/widgets/post.dart";

class TimelinePage extends StatefulWidget {
  const TimelinePage({ super.key });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> with Messages, CustomShimmer {
  bool _contentByPreference = true;
  CarouselController buttonCarouselController = CarouselController();
  final TimelineController _controller = Modular.get<TimelineController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getPosts(contentByPreference: this._contentByPreference);
    this._statusReactionDisposer = reaction((_) => this._controller.timelineStatus, (status) {
      switch (status) {
        case TimelineStateStatus.initial:
        case TimelineStateStatus.loadingPosts:
        case TimelineStateStatus.loadingComments:
        case TimelineStateStatus.savingComment:
        case TimelineStateStatus.loadedPosts:
        case TimelineStateStatus.loadedComments:
        case TimelineStateStatus.savedComment: break;
        case TimelineStateStatus.errorLoadComments:
        case TimelineStateStatus.errorSaveComment:
        case TimelineStateStatus.errorPosts:
        case TimelineStateStatus.errorPosts:
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
    return RefreshIndicator(
      onRefresh: this._controller.getPosts,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Align(
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
                    padding: const EdgeInsets.all(5),
                    isDense: true,
                    value: this._contentByPreference,
                    style: context.textStyles.textMedium.copyWith(fontSize: 12.sp, color: context.colors.primary),
                    underline: Container(),
                    onChanged: (bool? value) {
                      setState(() => this._contentByPreference = value ?? false);
                      this._controller.getPosts(contentByPreference: this._contentByPreference);
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
            )
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 14.sp),
                      )
                    );
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: this._controller.posts.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Post(
                        post: this._controller.posts[i],
                        commentsOfOpenedPost: this._controller.commentsOfOpenedPost,
                        onLike: this._controller.likePostById,
                        onLikeComment: this._controller.likeCommentById,
                        onLoadComments: this._controller.loadComments,
                        onComment: this._controller.saveComment
                      )
                    )
                  );
                }
              )
            )
          )
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 15),
          //     child: Observer(
          //       builder: (_) => ListView.builder(
          //         shrinkWrap: true,
          //         itemCount: this._controller.posts.length,
          //         itemBuilder: (_, i) => Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 6),
          //           child: Post(
          //             post: this._controller.posts[i],
          //             onLike: this._controller.likePostById,
          //             onLikeComment: this._controller.likeCommentById,
          //             onLoadComments: this._controller.loadComments
          //           )
          //         )
          //       )
          //     )
          //   )
          // )
        ]
      )
    );
  }
}




// class TimelinePage extends StatefulWidget {
//   const TimelinePage({ super.key });

//   @override
//   State<TimelinePage> createState() => _TimelinePageState();
// }

// class _TimelinePageState extends State<TimelinePage> {
//   bool _contentByPreference = true;
//   CarouselController buttonCarouselController = CarouselController();
//   final TimelineController _controller = Modular.get<TimelineController>();
//   late final ReactionDisposer _statusReactionDisposer;

//   @override
//   void initState() {
//     this._controller.getPosts(contentByPreference: this._contentByPreference);
//     this._statusReactionDisposer = reaction((_) => this._controller.timelineStatus, (status) {
//       switch (status) {
//         case TimelineStateStatus.initial:
//         case TimelineStateStatus.loading:
//         case TimelineStateStatus.success:
//         case TimelineStateStatus.error:
//           break;
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     this._statusReactionDisposer();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: RefreshIndicator(
//         onRefresh: () => this._controller.getPosts(),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Filtrar publicações: ",
//                       style: context.textStyles.textSemiBold.copyWith(color: Colors.white, fontSize: 12.sp),
//                     ),
//                     DropdownButton<bool>(
//                       icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
//                       padding: const EdgeInsets.all(5),
//                       isDense: true,
//                       value: this._contentByPreference,
//                       style: context.textStyles.textMedium.copyWith(fontSize: 12.sp, color: context.colors.primary),
//                       underline: Container(),
//                       onChanged: (bool? value) {
//                         setState(() => this._contentByPreference = value ?? false);
//                         this._controller.getPosts(contentByPreference: this._contentByPreference);
//                       },
//                       items: const [
//                         DropdownMenuItem<bool>(
//                           value: true,
//                           child: Text("Meus interesses")
//                         ),
//                         DropdownMenuItem<bool>(
//                           value: false,
//                           child: Text("Todos")
//                         )
//                       ]
//                     )
//                   ]
//                 )
//               )
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Observer(
//                   builder: (_) => ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: this._controller.posts.length,
//                     itemBuilder: (_, i) => const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 TitlePlaceholder(width: double.infinity),
//                 BannerPlaceholder(),
//                 SizedBox(height: 16.0),
//                 ContentPlaceholder(
//                   lineType: ContentLineType.threeLines,
//                 ),
//                 SizedBox(height: 16.0),
//                 TitlePlaceholder(width: 200.0),
//                 SizedBox(height: 16.0),
//                 ContentPlaceholder(
//                   lineType: ContentLineType.twoLines,
//                 ),
//                 SizedBox(height: 16.0),
//                 TitlePlaceholder(width: 200.0),
//                 SizedBox(height: 16.0),
//                 ContentPlaceholder(
//                   lineType: ContentLineType.twoLines,
//                 ),
//               ],
//             )
//                     // Post(
//                     //   post: this._controller.posts[i],
//                     //   onLike: this._controller.likePostById,
//                     //   onLikeComment: this._controller.likeCommentById,
//                     //   onLoadComments: this._controller.loadComments
//                     // )
//                   )
//                 )
//               )
//             )
//           ]
//         )
//       )
//     );
//   }
// }