import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'player_page.dart';
import '../providers/AudioPlayerModel.dart';
import '../providers/SubscriptionModel.dart';
import '../models/Media.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';
import '../widgets/MarqueeWidget.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key key}) : super(key: key);

  @override
  _AudioPlayout createState() => _AudioPlayout();
}

class _AudioPlayout extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    bool isSubscribed = Provider.of<SubscriptionModel>(context).isSubscribed;
    Provider.of<AudioPlayerModel>(context, listen: false)
        .setUserSubscribed(isSubscribed);
    Provider.of<AudioPlayerModel>(context, listen: false).setContext(context);
    return Consumer<AudioPlayerModel>(
      builder: (context, audioPlayerModel, child) {
        Media mediaItem = audioPlayerModel.currentMedia;
        return mediaItem == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  if (!audioPlayerModel.isRadio) {
                    Navigator.of(context).pushNamed(PlayPage.routeName);
                  }
                },
                child: Container(
                  height: 65,
                  //color: Colors.grey[900],
                  child: Card(
                      color: audioPlayerModel.backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      margin: EdgeInsets.all(0),
                      elevation: 10,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            mediaItem == null
                                ? Container()
                                : (mediaItem.coverPhoto == ""
                                    ? Icon(Icons.audiotrack)
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        child: Image(
                                          image: NetworkImage(
                                              mediaItem.coverPhoto),
                                        ),
                                      )),
                            Container(
                              width: 12,
                            ),
                            Expanded(
                              child: MarqueeWidget(
                                direction: Axis.horizontal,
                                child: Text(
                                  mediaItem != null ? mediaItem.title : "",
                                  maxLines: 1,
                                  style: TextStyles.subhead(context).copyWith(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ),
                            !audioPlayerModel.isRadio
                                ? IconButton(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    onPressed: () {
                                      audioPlayerModel.skipPrevious();
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container(
                                    width: 15,
                                  ),
                            ClipOval(
                                child: Container(
                              color:
                                  Theme.of(context).accentColor.withAlpha(30),
                              width: 50.0,
                              height: 50.0,
                              child: IconButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                onPressed: () {
                                  audioPlayerModel.onPressed();
                                },
                                icon: audioPlayerModel.icon(),
                              ),
                            )),
                            !audioPlayerModel.isRadio
                                ? IconButton(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    onPressed: () {
                                      audioPlayerModel.skipNext();
                                    },
                                    icon: const Icon(
                                      Icons.skip_next,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container(
                                    width: 15,
                                  ),
                            Container(
                              color: MyColors.primary,
                              //width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
      },
    );
  }
}
