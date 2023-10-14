import "dart:developer";

import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/modules/base/timeline/timeline_controller.dart";
import "package:sonorus/src/modules/base/timeline/widgets/post.dart";

class TimelinePage extends StatefulWidget {
  const TimelinePage({ super.key });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  CarouselController buttonCarouselController = CarouselController();
  final TimelineController _controller = Modular.get<TimelineController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getPosts();
    this._statusReactionDisposer = reaction((_) => this._controller.timelineStatus, (status) {
      switch (status) {
        case TimelineStateStatus.initial: break;
        case TimelineStateStatus.loading: break;
        case TimelineStateStatus.success: break;
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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 125,
            height: 45,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.filter_alt),
              label: const Text("Filtrar"),
              onPressed: () {
                // TO-DO: Abrir modal para filtrar as postagens pelo interesse e todos
              }
            )
          )
        ),
        const SizedBox(height: 20),
        Observer(
          builder: (_) => Expanded(
            child: RefreshIndicator(
              onRefresh: this._controller.getPosts,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: this._controller.posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (_, index) => Post(
                  post: this._controller.posts[index],
                  onLike: this._controller.likePostById,
                  onLikeComment: this._controller.likeCommentById,
                  onLoadComments: this._controller.loadComments
                )
              ),
            )
          )
        )
      ]
    );
  }
}