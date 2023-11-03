import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/utils/routes.dart";

import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/modules/base/widgets/picture_user.dart";

class SonorusAppBar extends PreferredSize {
  SonorusAppBar({ super.key }) : super(
    child: _SonorusAppBarContent(),
    preferredSize: const Size.fromHeight(80)
  );
}

class _SonorusAppBarContent extends StatelessWidget {
  final CurrentUserModel _currentUser = Modular.get<CurrentUserModel>();

  _SonorusAppBarContent();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF373739),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      title: InkWell(
        onTap: () => Modular.to.pushNamed(Routes.userPage),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PictureUser(
              picture: Image.network(
                this._currentUser.picture!,
                width: 50,
                height: 50,
                fit: BoxFit.cover
              )
            ),
            Text(
              this._currentUser.nickname!,
              style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 18.sp)
            )
          ]
        ),
      )
    );
  }
}