import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/models/message_model.dart";
import "package:sonorus/src/models/user_model.dart";

class Message extends StatelessWidget {
  final MessageModel message;
  final UserModel? friend;

  const Message.myMessage({
    super.key,
    required this.message
  }) : this.friend = null;

  const Message.friendMessage({
    super.key,
    required this.message,
    required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      margin: this.message.isSentByMe
        ? const EdgeInsets.only(left: 35)
        : const EdgeInsets.only(right: 35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF404048)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!this.message.isSentByMe)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.secondary,
                        blurRadius: 1,
                        spreadRadius: 3
                      )
                    ]
                  ),
                  child: ClipOval(
                    child: Image.network(
                      this.friend!.picture,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover
                    )
                  )
                ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  this.message.content,
                  style: context.textStyles.textMedium.copyWith(
                    color: Colors.white,
                    fontSize: 13.sp
                  )
                )
              )
            ]
          ),
          Text(
            this.message.sentAgo,
            textAlign: TextAlign.end,
            style: context.textStyles.textLight.copyWith(
              color: Colors.grey,
              fontSize: 10.sp
            )
          )
        ]
      )
    );
  }
}