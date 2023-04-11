import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/TextStyles.dart';
import '../models/Playlists.dart';
import '../i18n/strings.g.dart';
import '../providers/PlaylistsModel.dart';
import '../screens/PlaylistMediaScreen.dart';
import '../models/ScreenArguements.dart';
import 'dart:math';

class PlaylistsScreen extends StatefulWidget {
  static const routeName = "/myplaylists";
  @override
  MediaScreenRouteState createState() => new MediaScreenRouteState();
}

class MediaScreenRouteState extends State<PlaylistsScreen> {
  PlaylistsModel playlistsModel;
  List<Playlists> items;

  void clearPlaylistsMedia(BuildContext context, int id) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              t.clearplaylistmedias,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  t.cancel,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  t.ok,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  playlistsModel.deletePlaylistsMediaList(id);
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: Text(t.clearplaylistmediashint),
          );
        });
  }

  void deletePlaylist(BuildContext context, int id) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              t.deletePlayList,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  t.cancel,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  t.ok,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  playlistsModel.deletePlaylists(id);
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: Text(t.deletePlayListhint),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    playlistsModel = Provider.of<PlaylistsModel>(context);
    items = playlistsModel.playlistsList;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        title: Text(t.myplaylists),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: (items.length == 0)
                  ? Center(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(t.noitemstodisplay,
                              textAlign: TextAlign.center,
                              style: TextStyles.medium(context)),
                        ),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemCount: items.length,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(3),
                      itemBuilder: (BuildContext context, int index) {
                        List<String> choices = [
                          t.clearplaylistmedias,
                          t.deletePlayList
                        ];
                        Playlists playlists = items[index];
                        return InkWell(
                          child: ListTile(
                            //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              width: 40,
                              height: 40,
                              child: FutureBuilder<String>(
                                  initialData: "",
                                  future: playlistsModel
                                      .getPlayListFirstMediaThumbnail(
                                          playlists.id), //returns bool
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> value) {
                                    if (value.data == null || value.data == "")
                                      return Icon(
                                        Icons.music_note,
                                        size: 30,
                                        color: Colors.primaries[Random()
                                            .nextInt(Colors.primaries.length)],
                                      );
                                    else
                                      return CachedNetworkImage(
                                        imageUrl: value.data,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                            child:
                                                CupertinoActivityIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                child: Icon(
                                          Icons.error,
                                          color: Colors.grey,
                                        )),
                                      );
                                  }),
                            ),
                            title: Text(
                              playlists.title,
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: FutureBuilder<int>(
                                initialData: 0,
                                future: playlistsModel.getPlaylistMediaCount(
                                    playlists.id), //returns bool
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> value) {
                                  return Text(
                                    value.data == null
                                        ? "0 item"
                                        : value.data.toString() + " item(s)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  );
                                }),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            //subtitle:  Text(categories.interest, ),
                            trailing: PopupMenuButton(
                              elevation: 3.2,
                              //initialValue: choices[1],
                              itemBuilder: (BuildContext context) {
                                return choices.map((itm) {
                                  return PopupMenuItem(
                                    value: itm,
                                    child: Text(itm),
                                  );
                                }).toList();
                              },
                              //initialValue: 2,
                              onCanceled: () {
                                print("You have canceled the menu.");
                              },
                              onSelected: (value) {
                                print(value);
                                print(choices.indexOf(value));
                                switch (choices.indexOf(value)) {
                                  case 0:
                                    clearPlaylistsMedia(context, playlists.id);
                                    break;
                                  case 1:
                                    deletePlaylist(context, playlists.id);
                                    break;
                                  default:
                                }
                              },
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PlaylistMediaScreen.routeName,
                              arguments: ScreenArguements(
                                  position: 0, items: playlists),
                            );
                          },
                        );
                      },
                    ),
            ),
            //MiniPlayer(),
          ],
        ),
      ),
    );
  }
}
