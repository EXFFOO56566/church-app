import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostVideoPlayer extends StatefulWidget {
  PostVideoPlayer({this.videoURL});
  final String videoURL;

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends State<PostVideoPlayer> {
  BetterPlayerController _betterPlayerController;
  bool isVisible = false;

  @override
  void initState() {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.videoURL);
    _betterPlayerController = new BetterPlayerController(
        BetterPlayerConfiguration(
          aspectRatio: 3 / 2,
          autoPlay: false,
          allowedScreenSleep: false,
          //showControlsOnInitialize: true,
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(), //Key('my-widget-key'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = (visibilityInfo.visibleFraction * 100).floor();
        if (!mounted) return;
        if (visiblePercentage < 30 && _betterPlayerController != null) {
          // if (!isVisible) return;
          _betterPlayerController.pause();
          /* setState(() {
            isVisible = false;
          });*/
        }
        /*else {
          if (isVisible) return;
          setState(() {
            isVisible = true;
          });
          if (Provider.of<AppStateManager>(context, listen: false)
                  .autoPlayVideos &&
              _betterPlayerController != null) {
            //_betterPlayerController.play();
          }
        }*/
      },
      child: Container(
          height: 300,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: _betterPlayerController,
            ),
          )),
    );
  }
}
