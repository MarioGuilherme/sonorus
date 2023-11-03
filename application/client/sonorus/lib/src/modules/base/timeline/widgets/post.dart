import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/core/utils/routes.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/modules/base/timeline/widgets/comment.dart";
import "package:sonorus/src/modules/base/timeline/widgets/hash_tag.dart";
import "package:sonorus/src/modules/base/timeline/widgets/video_media_post.dart";
import "package:sonorus/src/modules/base/widgets/picture_user.dart";

class Post extends StatefulWidget {
  final PostModel post;
  final List<CommentModel> commentsOfOpenedPost;
  final Future<int> Function(int postId) onLike;
  final Future<int> Function(int commentId) onLikeComment;
  final Future<void> Function(int postId) onLoadComments;
  final Future<void> Function(int postId, String content) onComment;

  const Post({
    super.key,
    required this.post,
    required this.commentsOfOpenedPost,
    required this.onLike,
    required this.onLoadComments,
    required this.onLikeComment,
    required this.onComment
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final _messageEC = TextEditingController();

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
                          onTap: () => Modular.to.pushNamed(Routes.userPage, arguments: this.widget.post.author.userId),
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
                        Material(
                          color: Colors.transparent,
                          child: Ink(
                            child: InkWell(
                              onTap: () => Modular.to.pushNamed(Routes.userPage, arguments: this.widget.post.author.userId),
                              child: Text(
                                this.widget.post.author.nickname,
                                style: context.textStyles.textBold.copyWith(color: Colors.white, fontSize: 14.sp)
                              )
                            )
                          )
                        ),
                        Expanded(
                          child: Text(
                            this.widget.post.timeAgo,
                            textAlign: TextAlign.end,
                            style: context.textStyles.textThin.copyWith(color: Colors.white, fontSize: 10.sp)
                          )
                        )
                      ]
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            this.widget.post.content,
                            style: context.textStyles.textRegular.copyWith(color: Colors.white, fontSize: 12.sp)
                          )
                        )
                      ]
                    )
                  ]
                )
              ),
              if (this.widget.post.medias.isNotEmpty) ...[
                const SizedBox(height: 10),
                // LayoutBuilder(
                //   builder: (context, constraints) {
                //     return SizedBox(
                //       height: 250,
                //       child: ListView.builder(
                //         shrinkWrap: true,
                //         physics: const BouncingScrollPhysics(),
                //         scrollDirection: Axis.horizontal,
                //         itemCount: this.widget.post.medias.length,
                //         itemBuilder: (_, i) => SizedBox(
                //           width: constraints.maxWidth,
                //           child: this.widget.post.medias[i].isPicture
                //             ? Image.network(this.widget.post.medias[i].path)
                //             : VideoMediaPost(this.widget.post.medias[i].path)
                //         )
                //       )
                //     );
                //   }
                // )
                CarouselSlider.builder(
                  itemBuilder: (_, i, __) => this.widget.post.medias[i].isPicture
                    ? Image.network(this.widget.post.medias[i].path)
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
                  onPressed: () {} /* Fazer WS de buscar tablatura se tiver */,
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
                  onPressed: () {
                    this.widget.onLoadComments(this.widget.post.postId);
                    
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
                                padding: const EdgeInsets.all(15),
                                height: context.screenHeight,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF404048),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25)
                                  )
                                ),
                                child: Observer(
                                  builder: (_) {
                                    return Column(
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
                                        if (this.widget.commentsOfOpenedPost.isEmpty)
                                          Expanded(
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
                                          )
                                        else
                                          ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: this.widget.commentsOfOpenedPost.length,
                                            separatorBuilder: (_, index) => const SizedBox(height: 7.5),
                                            itemBuilder: (_, i) => Comment(
                                              comment: this.widget.commentsOfOpenedPost[i],
                                              onLikeComment: this.widget.onLikeComment
                                            )
                                          )
                                      ]
                                    );
                                  }
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
                                          onPressed: () => this.widget.onComment(this.widget.post.postId, this._messageEC.text)
                                        )
                                      )
                                    )
                                  )
                                ]
                              )
                            )
                          ]
                        ),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 91, 100),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)))
                  ),
                  icon: Icon(Icons.forum, color: context.colors.primary),
                  label: Text(
                    "${this.widget.post.totalComments}",
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