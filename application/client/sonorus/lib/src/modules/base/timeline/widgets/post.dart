import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:sonorus/src/models/comment_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/modules/base/timeline/widgets/comment.dart";

class Post extends StatefulWidget {
  final PostModel post;
  final Future<int> Function(int idPost) onLike;
  final Future<int> Function(int commentId) onLikeComment;
  final Future<List<CommentModel>> Function(int idPost) onLoadComments;

  const Post({
    super.key,
    required this.post,
    required this.onLike,
    required this.onLoadComments,
    required this.onLikeComment
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF404048)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
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
                          this.widget.post.author.picture,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover
                        )
                      )
                    ),
                    const SizedBox(width: 10),
                    Text(
                      this.widget.post.author.nickname,
                      style: context.textStyles.textBold.copyWith(color: Colors.white, fontSize: 16.sp),
                    ),
                    Expanded(
                      child: Text(
                        this.widget.post.timeAgo,
                        textAlign: TextAlign.end,
                        style: context.textStyles.textLight.copyWith(color: Colors.white, fontSize: 10.sp)
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
          if (this.widget.post.medias.isNotEmpty)
            CarouselSlider.builder(
              itemBuilder: (context, index, _) => Image.network(this.widget.post.medias[index].path),
              itemCount: this.widget.post.medias.length,
              options: CarouselOptions(
                height: 277,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                disableCenter: true
              )
            ),
          Row(
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
                    backgroundColor: const Color(0xFF404048),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10)
                      )
                    )
                  ),
                  icon: Icon(
                    this.widget.post.isLikedByMe
                      ? Icons.favorite
                      : Icons.favorite_border,
                    color: context.colors.primary
                  ),
                  label: Text("${this.widget.post.totalLikes}")
                )
              ),
              ElevatedButton(
                onPressed: null,// () {} /* Fazer WS de buscar tablatura se tiver */,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF404048),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  disabledBackgroundColor: context.colors.secondary.withAlpha(180)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/images/icons/iconTablature.png"),
                      const SizedBox(width: 8),
                      Text(
                        "Sem tablatura anexada",
                        style: context.textStyles.textLight.copyWith(fontSize: 12.sp, color: Colors.white)
                      )
                    ]
                  )
                )
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    this.widget.onLoadComments(this.widget.post.postId).then((comments) {
                      showModalBottomSheet(
                        useSafeArea: true,
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15
                          ),
                          height: context.screenHeight,
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
                                style: context.textStyles.textSemiBold.copyWith(color: Colors.white),
                              ),
                              const Divider(color: Colors.white),
                              if (comments.isEmpty)
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
                                  itemCount: comments.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 7.5),
                                  itemBuilder: (context, index) => Comment(
                                    comment: comments[index],
                                    onLikeComment: this.widget.onLikeComment,
                                  )
                                )
                            ]
                          )
                        )
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF404048),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10)
                      )
                    )
                  ),
                  icon: Icon(Icons.forum, color: context.colors.primary),
                  label: Text("${this.widget.post.totalComments}")
                ),
              ),
            ]
          )
        ]
      )
    );
  }
}