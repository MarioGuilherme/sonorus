import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";

import "package:sonorus/src/core/extensions/time_ago_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/view_models/post_view_model.dart";
import "package:sonorus/src/modules/navigation/post/widgets/hash_tag.dart";
import "package:sonorus/src/modules/navigation/post/widgets/video_media_post.dart";
import "package:sonorus/src/modules/navigation/widgets/picture_user.dart";

class Post extends StatefulWidget {
  final PostViewModel post;
  final Future<int> Function(int postId) onPressedLikeButton;
  final void Function(int postId) onPressedCommentsButton;
  final void Function(PostViewModel) onPressedEditButton;
  final Future<void> Function(int postId) onConfirmedDelete;

  const Post({
    super.key,
    required this.post,
    required this.onPressedLikeButton,
    required this.onPressedCommentsButton,
    required this.onPressedEditButton,
    required this.onConfirmedDelete
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with Messages, Loader {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(10)), color: Color(0xFF404048)),
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
                          child: PictureUser(picture: Image.network(this.widget.post.author.picture, width: 50, height: 50, fit: BoxFit.cover)),
                          onTap: () {
                            final bool isPostedByMe = Modular.get<AuthenticatedUser>().userId == this.widget.post.author.userId;
                            if (isPostedByMe) {
                              Modular.to.pushNamed("/profile/");
                              return;
                            }
                            Modular.to.pushNamed("/chat/", arguments: [this.widget.post.author]);
                          }
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: Ink(
                                child: InkWell(
                                  onTap: Modular.get<AuthenticatedUser>().userId != this.widget.post.author.userId
                                    ? () => Modular.to.pushNamed("/chat/", arguments: [this.widget.post.author])
                                    : null,
                                  child: Text(this.widget.post.author.nickname, style: context.textStyles.textBold.withFontSize(14)),
                                )
                              )
                            ),
                            Text(this.widget.post.postedAt.timeAgo, textAlign: TextAlign.end, style: context.textStyles.textThin.withFontSize(10))
                          ]
                        ),
                        if (Modular.get<AuthenticatedUser>().userId == this.widget.post.author.userId)
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
                                        this.showMessageWithActions(
                                          title: "Opções da publicações",
                                          message: "O que deseja fazer com esta publicação?",
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
                                                  message: "Deseja mesmo apagar esta publicação? Esta ação é irreversível!",
                                                  onConfirmButtonPressed: () async => this.widget.onConfirmedDelete(this.widget.post.postId)
                                                );
                                              }
                                            ),
                                            const SizedBox(width: 10,),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                                              label: const Text("Editar"),
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => this.widget.onPressedEditButton(this.widget.post)
                                            )
                                          ]
                                        );
                                      },
                                      child: const Icon(Icons.more_horiz, size: 28)
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
                          Flexible(child: Text(this.widget.post.content!,style: context.textStyles.textRegular.withFontSize(12)))
                        ]
                      )
                    ]
                  ]
                )
              ),
              if (this.widget.post.medias.isNotEmpty) ...[
                const SizedBox(height: 10),
                CarouselSlider.builder(
                  itemBuilder: (_, i, __) => !this.widget.post.medias[i].isPicture
                    ? VideoMediaPost(this.widget.post.medias[i].path)
                    : Image.network(
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
                      ),
                  itemCount: this.widget.post.medias.length,
                  options: CarouselOptions(height: 277, viewportFraction: 1, enableInfiniteScroll: false)
                )
              ],
              Padding(
                padding: const EdgeInsets.all(5),
                child: Wrap(children: this.widget.post.interests.map((interest) => HashTag(interest.key!)).toList())
              )
            ]
          )
        ),
        Container(
          decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)), color: Color(0xFF16161F)),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 91, 91, 100), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)))),
                  icon: Icon(this.widget.post.isLikedByMe ? Icons.favorite : Icons.favorite_border, color: context.colors.primary),
                  label: Text("${this.widget.post.totalLikes}", style: TextStyle(fontSize: 14.sp)),
                  onPressed: () async {
                    setState(() {
                      this.widget.post.isLikedByMe = !this.widget.post.isLikedByMe;
                      this.widget.post.totalLikes = this.widget.post.totalLikes + (this.widget.post.isLikedByMe ? 1 : -1);
                    });
                    final int totalLikes = await this.widget.onPressedLikeButton(this.widget.post.postId);
                    if (totalLikes == -1)
                      setState(() {                
                        this.widget.post.isLikedByMe = !this.widget.post.isLikedByMe;
                        this.widget.post.totalLikes = this.widget.post.totalLikes + (this.widget.post.isLikedByMe ? 1 : -1);
                      });
                  }
                )
              ),
              if (this.widget.post.tablature != null) ...[
                const SizedBox(width: 2.5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 91, 91, 100), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.zero))),
                  child: Icon(Icons.music_note, size: 22.sp),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      useSafeArea: true,
                      builder: (context) => PopScope(
                        onPopInvokedWithResult: (didPop, result) async => SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  child: const Icon(Icons.close),
                                  onPressed: () async {
                                    await SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);
                                    Modular.to.pop();
                                  }
                                )
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 8,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: FittedBox(
                                    child: Text(this.widget.post.tablature!, style: TextStyle(color: Colors.black, fontFamily: context.textStyles.monospaced))
                                  )
                                )
                              )
                            ]
                          )
                        )
                      )
                    );
                    await SystemChrome.setPreferredOrientations([ DeviceOrientation.landscapeLeft ]);
                  }
                )
              ],
              const SizedBox(width: 2.5),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => this.widget.onPressedCommentsButton(this.widget.post.postId),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 91, 91, 100), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)))),
                  icon: Icon(Icons.forum, color: context.colors.primary),
                  label: Text(this.widget.post.totalComments.toString(), style: TextStyle(fontSize: 14.sp))
                )
              )
            ]
          )
        )
      ]
    );
  }
}