import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/TimUtil.dart';
import '../widgets/MediaPopupMenu.dart';
import '../providers/AppStateManager.dart';
import '../screens/AddPlaylistScreen.dart';
import '../i18n/strings.g.dart';
import '../models/ScreenArguements.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:better_player/better_player.dart';
import 'dart:math' as math;
import '../utils/TextStyles.dart';
import '../models/Downloads.dart';
import '../screens/Downloader.dart';
import '../utils/my_colors.dart';
import '../models/Media.dart';
import '../screens/EmptyListScreen.dart';
import '../widgets/VideoItemTile.dart';
import '../utils/Utility.dart';
import '../models/Userdata.dart';
import '../providers/MediaPlayerModel.dart';
import '../video_player/YoutubePlayer.dart';
import '../widgets/Banneradmob.dart';
import '../providers/SubscriptionModel.dart';
import '../utils/Alerts.dart';

class VideoPlayer extends StatefulWidget {
  static const routeName = "/videoplayer";
  VideoPlayer({this.media, this.mediaList});
  final Media media;
  final List<Media> mediaList;

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends State<VideoPlayer>
    with TickerProviderStateMixin {
  Userdata userdata;
  bool isUserSubscribed = false;
  List<Media> playlist = [];
  bool expand1 = false;
  AnimationController controller1;
  Animation<double> animation1, animation1View;
  BetterPlayerController _betterPlayerController;
  Media currentMedia;
  Future<BetterPlayerController> reloadController;

  @override
  void initState() {
    userdata = Provider.of<AppStateManager>(context, listen: false).userdata;
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    animation1 = Tween(begin: 0.0, end: 180.0).animate(controller1);
    animation1View = CurvedAnimation(parent: controller1, curve: Curves.linear);

    playlist =
        Utility.removeCurrentMediaFromList(widget.mediaList, widget.media);
    currentMedia = widget.media;
    reloadController = playVideoStream();
    super.initState();
  }

  playVideoItem(Media media) {
    setState(() {
      playlist = Utility.removeCurrentMediaFromList(widget.mediaList, media);
      currentMedia = media;
      _betterPlayerController?.pause();
      if (currentMedia.videoType == "mp4_video" ||
          currentMedia.videoType == "video_link" ||
          currentMedia.videoType == "mpd_video" ||
          currentMedia.videoType == "m3u8_video") {
        reloadController = playVideoStream();
      }
    });
  }

  Future<BetterPlayerController> playVideoStream() async {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, currentMedia.streamUrl);
    _betterPlayerController = new BetterPlayerController(
        BetterPlayerConfiguration(
          aspectRatio: 3 / 2,
          placeholder: CachedNetworkImage(
            imageUrl: currentMedia.coverPhoto,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                Center(child: CupertinoActivityIndicator()),
            errorWidget: (context, url, error) => Center(
                child: Icon(
              Icons.error,
              color: Colors.grey,
            )),
          ),
          autoPlay: Provider.of<AppStateManager>(context, listen: false)
              .autoPlayVideos,
          allowedScreenSleep: false,
          // showControlsOnInitialize: true,
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    _betterPlayerController.addEventsListener((event) {
      if (!mounted) return;
      print("Better player event: ${event.betterPlayerEventType}");
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        if (Utility.isPreviewDuration(
            currentMedia,
            TimUtil.parseDuration(event.parameters["progress"].toString()),
            isUserSubscribed)) {
          _betterPlayerController?.pause();
          Alerts.showPreviewSubscribeAlertDialog(context);
        }
      }
    });

    return _betterPlayerController;
  }

  void togglePanel1() {
    if (!expand1) {
      controller1.forward();
    } else {
      controller1.reverse();
    }
    expand1 = !expand1;
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isUserSubscribed = Provider.of<SubscriptionModel>(context).isSubscribed;
    return ChangeNotifierProvider(
      create: (context) => MediaPlayerModel(userdata, widget.media),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(height: 270, child: buildVideoContainer(currentMedia)),
              (playlist.length == 0)
                  ? Expanded(
                      child: Column(
                        children: <Widget>[
                          getInfoContainer(),
                          Expanded(
                            child: EmptyListScreen(
                              message: t.emptyplaylist,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: playlist.length + 1,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(3),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return getInfoContainer();
                          }
                          return VideoItemTile(
                            onclick: playVideoItem,
                            object: playlist[index - 1],
                          );
                        },
                      ),
                    ),
              Banneradmob(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVideoContainer(Media currentMedia) {
    if (currentMedia.videoType == "mp4_video" ||
        currentMedia.videoType == "video_link" ||
        currentMedia.videoType == "mpd_video" ||
        currentMedia.videoType == "m3u8_video") {
      return FutureBuilder<BetterPlayerController>(
        future: reloadController,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return AspectRatio(
              aspectRatio: 3 / 2,
              child: BetterPlayer(
                controller: snapshot.data,
              ),
            );
          }
        },
      );
    } else if (currentMedia.videoType == "youtube_video") {
      return YoutubeVideoPlayer(media: currentMedia, key: UniqueKey());
    } else {
      return Container(
        child: Text("Not yet Supported"),
      );
    }
  }

  Widget getInfoContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      // height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            //height: 50,
            child: Stack(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    togglePanel1();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 30, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(currentMedia.title,
                          maxLines: 3,
                          style: TextStyles.headline(context).copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.rotate(
                    angle: animation1.value * math.pi / 180,
                    child: IconButton(
                      icon: Icon(Icons.expand_more),
                      onPressed: () {
                        togglePanel1();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 0),
          SizeTransition(
            sizeFactor: animation1View,
            child: Text(currentMedia.description,
                maxLines: 5,
                style: TextStyles.subhead(context).copyWith(
                  fontSize: 17,
                  color: MyColors.grey_90,
                )),
          ),
          Divider(),
          Container(height: 10),
          MediaCommentsLikesContainer(
              key: UniqueKey(), context: context, currentMedia: currentMedia),
          Divider(),
          Container(height: 5),
        ],
      ),
    );
  }
}

class MediaCommentsLikesContainer extends StatefulWidget {
  const MediaCommentsLikesContainer({
    Key key,
    @required this.context,
    @required this.currentMedia,
  }) : super(key: key);

  final BuildContext context;
  final Media currentMedia;

  @override
  _MediaCommentsLikesContainerState createState() =>
      _MediaCommentsLikesContainerState();
}

class _MediaCommentsLikesContainerState
    extends State<MediaCommentsLikesContainer> {
  @override
  void initState() {
    Provider.of<MediaPlayerModel>(context, listen: false)
        .setMediaLikesCommentsCount(widget.currentMedia);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaPlayerModel>(
      builder: (context, mediaPlayerModel, child) {
        return Container(
          height: 50,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: () {
                  mediaPlayerModel
                      .likePost(mediaPlayerModel.isLiked ? "unlike" : "like");
                },
                child: Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: FaIcon(FontAwesomeIcons.thumbsUp,
                        size: 28,
                        color: mediaPlayerModel.isLiked
                            ? Colors.pink
                            : Colors.grey[500]),
                  ),
                  mediaPlayerModel.likesCount == 0
                      ? Container()
                      : Text(mediaPlayerModel.likesCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                ]),
              ),
              InkWell(
                onTap: () {
                  mediaPlayerModel.navigatetoCommentsScreen(context);
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.insert_comment,
                        size: 28, color: Colors.grey[600]),
                    mediaPlayerModel.commentsCount == 0
                        ? Container()
                        : Text(mediaPlayerModel.commentsCount.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddPlaylistScreen.routeName,
                    arguments: ScreenArguements(
                        position: 0, items: widget.currentMedia),
                  );
                },
                child:
                    Icon(Icons.playlist_add, size: 28, color: Colors.grey[600]),
              ),
              InkWell(
                onTap: () {
                  Downloads downloads =
                      Downloads.mapCurrentDownloadMedia(widget.currentMedia);
                  Navigator.pushNamed(context, Downloader.routeName,
                      arguments: ScreenArguements(
                        position: 0,
                        items: downloads,
                      ));
                },
                child: Icon(Icons.file_download,
                    size: 28, color: Colors.grey[600]),
              ),
              InkWell(
                  onTap: () {
                    Share.shareFile(widget.currentMedia);
                  },
                  child: Icon(Icons.share, size: 28, color: Colors.grey[600])),
            ],
          ),
        );
      },
    );
  }
}
