import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/modules/timeline/timeline_controller.dart";

class TimelinePage extends StatefulWidget {
  const TimelinePage({ super.key });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TimelineController _controller = Modular.get<TimelineController>();
  late final ReactionDisposer _statusReactionDisposer;
  late final CurrentUserModel _currentUser;

  @override
  void initState() {
    this._currentUser = Modular.get<CurrentUserModel>();
    this._statusReactionDisposer = reaction((_) => this._controller.timelineStatus, (status) {
      switch (status) {
        case TimelineStateStatus.initial: break;
        case TimelineStateStatus.error:
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this._statusReactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            title: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black, spreadRadius: 2)],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28,
                    backgroundImage: NetworkImage("https://mgaroteste1.blob.core.windows.net/pictures-user/${this._currentUser.picture!}"),
                  )
                )
              ]
            ),
            toolbarHeight: 70,
            backgroundColor: const Color(0xFF373739),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
            ),
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.chat, size: 42, color: context.colors.primary)
                  )
                )
              )
            ]
          )
        ),
        backgroundColor: context.colors.secondary,
        body: const Text("Ola")
      )
    );
  }
}