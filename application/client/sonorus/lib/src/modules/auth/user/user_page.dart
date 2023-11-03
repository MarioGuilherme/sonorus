import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/user_model.dart";

import "package:sonorus/src/modules/auth/user/user_controller.dart";

class UserPage extends StatelessWidget {
  final int userId;

  UserPage({ super.key, int? userId}) : this.userId = userId ?? Modular.get<CurrentUserModel>().userId!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.userId.toString()),),
      body: Container()
    );
  }
}