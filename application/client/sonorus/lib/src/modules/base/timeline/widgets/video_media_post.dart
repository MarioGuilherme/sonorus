import "dart:async";
import "dart:developer";

import "package:flutter/material.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";
import "package:video_player/video_player.dart";

class VideoMediaPost extends StatefulWidget {
  final String path;

  const VideoMediaPost(this.path, { super.key });

  @override
  State<VideoMediaPost> createState() => _VideoMediaPostState();
}

class _VideoMediaPostState extends State<VideoMediaPost> {
  late VideoPlayerController _controller;
  double _opacity = 1;
  Duration _duration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    this._controller = VideoPlayerController.networkUrl(Uri.parse(this.widget.path))..initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }

  void _fadeOutContainer() => setState(() => this._opacity = 0);
  void _fadeInContainer() => setState(() => this._opacity = 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        if (this._controller.value.isPlaying) {
          this._duration = const Duration(milliseconds: 100);
          this._controller.pause();
          this._fadeInContainer();
        } else {
          this._duration = const Duration(seconds: 1);
          this._controller.play();
          this._fadeOutContainer();
        }
      }),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            this._controller.value.isInitialized
              ? VideoPlayer(this._controller)
              : const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
            if (this._controller.value.isInitialized && !this._controller.value.isBuffering && !this._controller.value.isPlaying)
              Align(
                child: ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: context.colors.secondary,
                    child: Icon(
                      Icons.play_arrow,
                      color: context.colors.primary,
                      size: 32
                    )
                  )
                )
              ),
            if (this._controller.value.isBuffering)
              Align(
                child: ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: context.colors.secondary,
                    child: const CircularProgressIndicator()
                  )
                )
              ),
            if (this._controller.value.isCompleted)
              Align(
                child: ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: context.colors.secondary,
                    child: Icon(
                      Icons.replay,
                      color: context.colors.primary,
                      size: 32
                    )
                  )
                )
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: this._opacity,
                duration: this._duration,
                child: SizedBox(
                  height: 35,
                  child: Slider(
                    min: 0,
                    value: this._controller.value.position.inSeconds.toDouble(),
                    max: this._controller.value.duration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      await this._controller.seekTo(Duration(seconds: value.toInt()));
                      setState(() {});
                    }
                  )
                )
              )
            )
          ]
        ),
      )
    );
  }
}