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
    preferredSize: const Size.fromHeight(50)
  );
}

class _SonorusAppBarContent extends StatelessWidget {
  final CurrentUserModel _currentUser = Modular.get<CurrentUserModel>();

  _SonorusAppBarContent();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 50,
      floating: true,
      snap: true,
      titleSpacing: 0,
      backgroundColor: const Color(0xFF373739),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.5))),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: InkWell(
          onTap: () => Modular.to.pushNamed(Routes.userPage),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PictureUser(
                picture: Image.network(
                  this._currentUser.picture!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover
                )
              ),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  "asd asdasdasd asd asdasddasdasddasdasddasdasdd",
                  style: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 16.sp)
                )
              )
            ]
          )
        ),
      )
    );
  }
}