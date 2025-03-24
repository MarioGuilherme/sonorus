import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:intl/intl.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/view_models/message_view_model.dart";
import "package:sonorus/src/dtos/view_models/user_view_model.dart";
import "package:sonorus/src/modules/navigation/widgets/picture_user.dart";

class Message extends StatelessWidget {
  final MessageViewModel messageViewModel;
  final UserViewModel? author;

  const Message.myMessage({
    super.key,
    required this.messageViewModel
  }) : this.author = null;

  const Message.friendMessage({
    super.key,
    required this.messageViewModel,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    final int myUserId = Modular.get<AuthenticatedUser>().userId!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          margin: this.messageViewModel.sentByUserId == myUserId ? const EdgeInsets.only(left: 35) : const EdgeInsets.only(right: 35),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF404048)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (this.messageViewModel.sentByUserId != myUserId)
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.white, blurRadius: 1, spreadRadius: 3)
                        ]
                      ),
                      child: PictureUser(picture: Image.network(this.author!.picture, width: 50, height: 50, fit: BoxFit.cover))
                    ),
                  const SizedBox(width: 10),
                  Flexible(child: Text(this.messageViewModel.content, style: context.textStyles.textMedium.withFontSize(13)))
                ]
              ),
              if (this.messageViewModel.sentAt != null)
                Text(
                  DateFormat("dd/MM/yyyy 'às' HH:mm:ss").format(this.messageViewModel.sentAt!),
                  textAlign: TextAlign.end,
                  style: context.textStyles.textLight.copyWith(color: Colors.grey, fontSize: 11.sp)
                )
            ]
          )
        ),
        if (this.messageViewModel.sentAt == null)
          Container(
            alignment: Alignment.centerRight,
            height: 10,
            width: 10,
            child: const CircularProgressIndicator()
          )
      ]
    );
  }
}