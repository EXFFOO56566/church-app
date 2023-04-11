import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utils/TimUtil.dart';
import '../models/Media.dart';
import 'package:provider/provider.dart';
import '../providers/SubscriptionModel.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final Media media;
  YoutubeVideoPlayer({Key key, @required this.media}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<YoutubeVideoPlayer>
    with WidgetsBindingObserver {
  YoutubePlayerController _controller;
  bool isUserSubscribed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = YoutubePlayerController(
      initialVideoId: widget.media.streamUrl,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller?.pause();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //_controller?.dispose();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isUserSubscribed = Provider.of<SubscriptionModel>(context).isSubscribed;
    return YoutubePlayer(
      controller: _controller,
      onReady: () {
        _controller.addListener(listener);
      },
      showVideoProgressIndicator: true,
      bottomActions: <Widget>[
        const SizedBox(width: 14.0),
        CurrentPosition(),
        const SizedBox(width: 8.0),
        ProgressBar(isExpanded: true),
        RemainingDuration(),
        const PlaybackSpeedButton(),
      ],
    );
  }

  void listener() {
    if (!mounted) return;
    if (Utility.isPreviewDuration(
        widget.media,
        TimUtil.parseDuration(_controller.value.position.toString()),
        isUserSubscribed)) {
      _controller?.pause();
      Alerts.showPreviewSubscribeAlertDialog(context);
    }
  }
}
