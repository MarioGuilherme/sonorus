import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/extensions/time_ago_extension.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/models/chat_model.dart";

class Chat extends StatelessWidget {
  final ChatModel chat;

  const Chat({ super.key, required this.chat });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        child: Ink(
          color: const Color(0xFF404048),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Modular.to.pushNamed("/chat", arguments: this.chat),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.5),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      border: Border.all(
                        color: context.colors.primary,
                        width: 1
                      )
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Image.network(
                        this.chat.friend!.picture,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover
                      )
                    )
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            this.chat.friend!.nickname,
                            style: context.textStyles.textExtraBold.copyWith(
                              color: Colors.white,
                              fontSize: 14.sp
                            )
                          ),
                          Text(
                            "${this.chat.messages!.first.isSentByMe ? "Você: " : ""}${this.chat.messages!.first.content}",
                            style: context.textStyles.textRegular.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp
                            )
                          )
                        ]
                      )
                    )
                  ),
                  Text(
                    this.chat.messages!.first.sentAt.timeAgo,
                    style: context.textStyles.textLight.copyWith(
                      color: Colors.white,
                      fontSize: 8.sp
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}