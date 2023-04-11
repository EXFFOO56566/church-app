import 'package:flutter/material.dart';
import '../providers/MediaPlayerModel.dart';
import '../models/Media.dart';
import '../providers/AudioPlayerModel.dart';
import '../providers/SubscriptionModel.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';
import 'package:provider/provider.dart';
import '../widgets/MediaPopupMenu.dart';

class SongListCarousel extends StatefulWidget {
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<SongListCarousel> {
  Widget _buildSongItem(Media data) {
    AudioPlayerModel audioPlayerModel = Provider.of(context);
    return data.id == audioPlayerModel.currentMedia.id
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: EdgeInsets.all(10),
                color: Theme.of(context).accentColor.withAlpha(90),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                          width: 50,
                          height: 50,
                          child: Image.network(data.coverPhoto)),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data.title,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.category,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                    ),
                    MediaPopupMenu(data),
                  ],
                ),
              ),
            ),
          )
        : Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                      width: 50,
                      height: 50,
                      child: Image.network(data.coverPhoto)),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data.title,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data.category,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                ),
                MediaPopupMenu(data),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    bool isSubscribed = Provider.of<SubscriptionModel>(context).isSubscribed;
    AudioPlayerModel audioPlayerModel = Provider.of(context);
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: audioPlayerModel.currentPlaylist.length,
        itemBuilder: (BuildContext context, int index) {
          Media media = audioPlayerModel.currentPlaylist[index];
          return GestureDetector(
            onTap: () {
              if (Utility.isMediaRequireUserSubscription(media, isSubscribed)) {
                Alerts.showPlaySubscribeAlertDialog(context);
                return;
              }
              audioPlayerModel.startAudioPlayBack(media);
              Provider.of<MediaPlayerModel>(context, listen: false)
                  .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
            },
            child: _buildSongItem(media),
          );
        },
      ),
    );
  }
}
