import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/models/current_user_model.dart";

class SonorusAppBar extends PreferredSize {
  SonorusAppBar({ super.key }) : super(
    child: _SonorusAppBarContent(),
    preferredSize: const Size.fromHeight(55),
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
      actions: [
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
              this._currentUser.picture!,
              width: 50,
              height: 50,
              fit: BoxFit.cover
            )
          )
        )
      ]
    );
  }
}