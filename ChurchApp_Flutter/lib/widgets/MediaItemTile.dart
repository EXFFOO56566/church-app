import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/Media.dart';
import '../widgets/MediaPopupMenu.dart';
import '../video_player/VideoPlayer.dart';
import '../models/ScreenArguements.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';
import '../providers/AudioPlayerModel.dart';
import '../audio_player/player_page.dart';
import '../providers/SubscriptionModel.dart';

class ItemTile extends StatefulWidget {
  final Media object;
  final List<Media> mediaList;
  final int index;

  const ItemTile({
    Key key,
    @required this.mediaList,
    @required this.index,
    @required this.object,
  })  : assert(mediaList != null),
        assert(index != null),
        assert(object != null),
        super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    bool isSubscribed = Provider.of<SubscriptionModel>(context).isSubscribed;
    return InkWell(
      onTap: () {
        if (Utility.isMediaRequireUserSubscription(
            widget.object, isSubscribed)) {
          Alerts.showPlaySubscribeAlertDialog(context);
          return;
        }
        if (widget.object.mediaType.toLowerCase() == "audio") {
          Provider.of<AudioPlayerModel>(context, listen: false).preparePlaylist(
              Utility.extractMediaByType(
                  widget.mediaList, widget.object.mediaType),
              widget.object);
          Navigator.of(context).pushNamed(PlayPage.routeName);
        } else {
          Navigator.pushNamed(context, VideoPlayer.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: widget.object,
                itemsList: Utility.extractMediaByType(
                    widget.mediaList, widget.object.mediaType),
              ));
        }
      },
      child: Container(
        height: 130,
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
                        height: 80,
                        width: 80,
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
                                maxLines: 2,
                                style: TextStyles.subhead(context).copyWith(
                                    //color: MyColors.grey_80,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            widget.object.viewsCount == 0
                                ? Container()
                                : Text(
                                    widget.object.viewsCount.toString() +
                                        " view(s)",
                                    style: TextStyles.caption(context)
                                    //.copyWith(color: MyColors.grey_60),
                                    ),
                            Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: MediaPopupMenu(widget.object),
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
            Divider(
              height: 0.1,
              //color: Colors.grey.shade800,
            )
          ],
        ),
      ),
    );
  }
}
