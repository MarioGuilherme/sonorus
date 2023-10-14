import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/models/comment_model.dart";

class Comment extends StatefulWidget {
  final CommentModel comment;
  final Future<int> Function(int commentId) onLikeComment;

  const Comment({
    super.key,
    required this.comment,
    required this.onLikeComment
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
              this.widget.comment.user.picture,
              width: 50,
              height: 50,
              fit: BoxFit.cover
            )
          ),
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
                  this.widget.comment.user.nickname,
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
                  this.widget.comment.timeAgo,
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
    );
  }
}