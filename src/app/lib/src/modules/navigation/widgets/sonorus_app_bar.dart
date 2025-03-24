import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";

import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/modules/navigation/widgets/picture_user.dart";

class SonorusAppBar extends PreferredSize {
  SonorusAppBar({ required onBackProfilePage, super.key }) : super(
    child: SonorusAppBarContent(onBackProfilePage: onBackProfilePage),
    preferredSize: const Size.fromHeight(55)
  );
}

class SonorusAppBarContent extends StatelessWidget {
  final VoidCallback onBackProfilePage;

  const SonorusAppBarContent({ required this.onBackProfilePage, super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticatedUser authenticatedUser = Modular.get<AuthenticatedUser>();
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.5)),
      child: Material(
        surfaceTintColor: Colors.white,
        color:  Color(0xFF373739),
        child: Ink(
          child: InkWell(
            onTap: () => Modular.to.pushNamed("/profile", arguments: authenticatedUser).then((_) => this.onBackProfilePage()),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PictureUser(picture: Image.network(authenticatedUser.picture!, width: 45, height: 50, fit: BoxFit.cover)),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      authenticatedUser.nickname!,
                      style: context.textStyles.textMedium.withFontSize(16)
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