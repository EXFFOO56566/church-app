import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/DownloadsModel.dart';
import '../models/Downloads.dart';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/cupertino.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import '../i18n/strings.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/MediaPopupMenu.dart';
import '../video_player/VideoPlayer.dart';
import '../models/ScreenArguements.dart';
import '../utils/Utility.dart';
import '../providers/AudioPlayerModel.dart';
import '../audio_player/player_page.dart';

class Downloader extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  static const routeName = "/downloader";
  final Downloads downloads;

  Downloader({Key key, this.downloads, this.platform}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Downloader> {
  DownloadsModel downloadsModel;
  final TextEditingController inputController = new TextEditingController();
  bool showClear = false;
  String filter;

  @override
  void initState() {
    Provider.of<DownloadsModel>(context, listen: false)
        .initDownloads(widget.platform, widget.downloads);
    inputController.addListener(() {
      setState(() {
        filter = inputController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //downloadsModel.unbindBackgroundIsolate();
    inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    downloadsModel = Provider.of<DownloadsModel>(context);

    return new Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onSubmitted: (query) {
            //downloadsModel.searchDownloads(query);
          },
          /* onChanged: (term) {
            setState(() {
              showClear = (term.length > 2);
            });
            if (term.length == 0) {
              //downloadsModel.cancelSearch();
            }
          },*/
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: t.downloads,
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    downloadsModel.cancelSearch();
                  },
                )
              : Container(),
        ],
      ),
      /*new AppBar(
        title: new Text(Strings.downloads),
        
      ),*/
      body: BuildBodyPage(downloadsModel: downloadsModel, filter: filter),
    );
  }
}

class BuildBodyPage extends StatelessWidget {
  const BuildBodyPage({
    Key key,
    @required this.downloadsModel,
    @required this.filter,
  }) : super(key: key);

  final DownloadsModel downloadsModel;
  final String filter;

  @override
  Widget build(BuildContext context) {
    if (downloadsModel.isLoading)
      return new Center(
        child: new CircularProgressIndicator(),
      );
    if (!downloadsModel.permissionReady) {
      return new Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  t.grantstoragepermission,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              TextButton(
                  onPressed: () {
                    downloadsModel.requestPermission();
                  },
                  child: Text(
                    t.retry,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ))
            ],
          ),
        ),
      );
    }
    if (downloadsModel.permissionReady &&
        downloadsModel.downloadsList.length == 0) {
      return Center(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(t.noitemstodisplay,
                textAlign: TextAlign.center, style: TextStyles.medium(context)),
          ),
        ),
      );
    }
    return Container(
      child: ListView.builder(
          itemCount: downloadsModel.downloadsList.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(3),
          itemBuilder: (BuildContext context, int index) {
            return filter == null || filter == ""
                ? ItemTile(
                    index: index,
                    object: downloadsModel.downloadsList[index],
                    downloadsModel: downloadsModel)
                : downloadsModel.downloadsList[index].title
                        .toLowerCase()
                        .contains(filter.toLowerCase())
                    ? ItemTile(
                        index: index,
                        object: downloadsModel.downloadsList[index],
                        downloadsModel: downloadsModel)
                    : new Container();
          }),
    );
  }
}

class ItemTile extends StatefulWidget {
  final Downloads object;
  final int index;
  final DownloadsModel downloadsModel;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.object,
    @required this.downloadsModel,
  })  : assert(index != null),
        assert(object != null),
        assert(downloadsModel != null),
        super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.object.status != DownloadTaskStatus.complete) {
          return;
        }
        if (widget.object.mediaType.toLowerCase() == "audio") {
          Provider.of<AudioPlayerModel>(context, listen: false).preparePlaylist(
              Downloads.mapMediaListFromDownloadList(
                  widget.downloadsModel.downloadsList),
              Downloads.mapMediaFromDownload(widget.object));
          Navigator.of(context).pushNamed(PlayPage.routeName);
        } else {
          Navigator.pushNamed(context, VideoPlayer.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: Downloads.mapMediaFromDownload(widget.object),
                itemsList: Utility.extractMediaByType(
                    Downloads.mapMediaListFromDownloadList(
                        widget.downloadsModel.downloadsList),
                    widget.object.mediaType),
              ));
        }
      },
      child: Container(
        height: 140,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Card(
                      margin: EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: 60,
                        width: 60,
                        child: CachedNetworkImage(
                          imageUrl: widget.object.coverPhoto,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black12, BlendMode.darken)),
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
                      )),
                  Container(width: 10),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 4, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Text(widget.object.category,
                                  style: TextStyles.caption(context)
                                  //.copyWith(color: MyColors.grey_60),
                                  ),
                              Spacer(),
                              Text(
                                  TimUtil.timeFormatter(widget.object.duration),
                                  style: TextStyles.caption(context)
                                  //.copyWith(color: MyColors.grey_60),
                                  ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.object.title,
                                maxLines: 1,
                                style: TextStyles.subhead(context).copyWith(
                                    //color: MyColors.grey_80,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                                widget.object.mediaType[0].toUpperCase() +
                                    widget.object.mediaType.substring(1),
                                style: TextStyles.caption(context)
                                //.copyWith(color: MyColors.grey_60),
                                ),
                            Spacer(),
                            widget.object.status == DownloadTaskStatus.complete
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: MediaPopupMenu(
                                      Downloads.mapMediaFromDownload(
                                          widget.object),
                                      isDownloads: true,
                                    ),
                                  )
                                : new Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: _buildActionForTask(widget.object),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 0,
            ),
            widget.object.status == DownloadTaskStatus.running ||
                    widget.object.status == DownloadTaskStatus.paused
                ? LinearProgressIndicator(
                    value: widget.object.progress / 100,
                  )
                : new Container(),
            Divider()
          ],
        ),
      ),
    );
  }

  Widget _buildActionForTask(Downloads task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return new RawMaterialButton(
        onPressed: () {
          widget.downloadsModel.requestDownload(task);
        },
        child: new Icon(Icons.file_download),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return new RawMaterialButton(
        onPressed: () {
          widget.downloadsModel.pauseDownload(task);
        },
        child: new Icon(
          Icons.pause,
          color: Colors.red,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return new RawMaterialButton(
        onPressed: () {
          widget.downloadsModel.resumeDownload(task);
        },
        child: new Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text(
            'Ready',
            style: new TextStyle(color: Colors.green),
          ),
          RawMaterialButton(
            onPressed: () {
              widget.downloadsModel.delete(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return new Text('Canceled', style: new TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text('Failed', style: new TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              widget.downloadsModel.retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }
}
