import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/extensions/time_ago_extension.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/view_models/chat_view_model.dart";

class Chat extends StatelessWidget {
  final ChatViewModel chat;

  const Chat({ super.key, required this.chat });

  @override
  Widget build(BuildContext context) {
    final int myUserId = Modular.get<AuthenticatedUser>().userId!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        child: Ink(
          color: const Color(0xFF404048),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Modular.to.pushNamed("/chat/", arguments: [this.chat.participants.firstWhere((c) => c.userId != myUserId)]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.5),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(200), border: Border.all(color: context.colors.primary, width: 1)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Image.network(
                        this.chat.participants.firstWhere((p) => p.userId != myUserId).picture,
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
                          Text(this.chat.participants.firstWhere((p) => p.userId != myUserId).nickname, style: context.textStyles.textExtraBold.withFontSize(14)),
                          Text("${this.chat.messages.first.sentByUserId == myUserId ? "Você: " : ""}${this.chat.messages.first.content}", style: context.textStyles.textRegular.withFontSize(13))
                        ]
                      )
                    )
                  ),
                  Text(this.chat.messages.first.sentAt!.timeAgo, style: context.textStyles.textLight.withFontSize(8))
                ]
              )
            )
          )
        )
      )
    );
  }
}
