import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../providers/AppStateManager.dart';
import '../models/Media.dart';
import '../i18n/strings.g.dart';
import '../providers/VideoScreensModel.dart';
import '../screens/NoitemScreen.dart';
import '../widgets/MediaItemTile.dart';

class VideoScreen extends StatefulWidget {
  static const routeName = "/videoscreen";
  VideoScreen();

  @override
  VideoScreenRouteState createState() => new VideoScreenRouteState();
}

class VideoScreenRouteState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoScreensModel(
          Provider.of<AppStateManager>(context, listen: false).userdata),
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.videomessages),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 12),
          child: VideoScreenBody(),
        ),
      ),
    );
  }
}

class VideoScreenBody extends StatefulWidget {
  @override
  MediaScreenRouteState createState() => new MediaScreenRouteState();
}

class MediaScreenRouteState extends State<VideoScreenBody> {
  VideoScreensModel mediaScreensModel;
  List<Media> items;

  void _onRefresh() async {
    mediaScreensModel.loadItems();
  }

  void _onLoading() async {
    mediaScreensModel.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<VideoScreensModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<VideoScreensModel>(context);
    items = mediaScreensModel.mediaList;

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: mediaScreensModel.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (mediaScreensModel.isError == true && items.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  mediaList: items,
                  index: index,
                  object: items[index],
                );
              },
            ),
    );
  }
}
