import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/PlaylistsModel.dart';
import '../models/Media.dart';
import '../models/Playlists.dart';
import '../utils/TextStyles.dart';
import 'dart:math';
import '../utils/my_colors.dart';
import '../i18n/strings.g.dart';
import 'package:flutter/cupertino.dart';

class AddPlaylistScreen extends StatelessWidget {
  static const routeName = "/addplaylists";
  final Media media;
  AddPlaylistScreen({this.media});

  void newPlaylistDialog(BuildContext context, PlaylistsModel playlistsModel) {
    String name = "";
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              t.newplaylist,
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
                  if (name != "") {
                    playlistsModel.createPlaylist(name, media.mediaType);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
            content: TextField(
              autofocus: true,
              onChanged: (text) {
                name = text;
              },
              // cursorColor: Colors.black,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    PlaylistsModel playlistsModel = Provider.of<PlaylistsModel>(context);
    List<Playlists> items = playlistsModel.playlistsList;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.addtoplaylist),
      ),
      body: Container(
        // decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            InkWell(
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 20, 10, 5),
                leading: Container(
                  width: 40,
                  height: 40,
                  color: MyColors.primary,
                  child: Center(
                    child: Icon(
                      Icons.playlist_add,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  t.newplaylist,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                newPlaylistDialog(context, playlistsModel);
              },
            ),
            Divider(),
            Expanded(
                child: items.length == 0
                    ? Center(
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(t.noitemstodisplay,
                                textAlign: TextAlign.center,
                                style: TextStyles.medium(context)),
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(0),
                        child: ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(height: 1, color: Colors.grey),
                          itemBuilder: (context, index) {
                            return Container(
                                height: 70,
                                child: Items(
                                    media: media,
                                    playlists: items[index],
                                    playlistsModel: playlistsModel));
                          },
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}

class Items extends StatelessWidget {
  const Items({
    Key key,
    @required this.media,
    @required this.playlists,
    @required this.playlistsModel,
  }) : super(key: key);

  final Media media;
  final Playlists playlists;
  final PlaylistsModel playlistsModel;

  addMediaToPlaylist(BuildContext context, bool isAdded) {
    if (!isAdded) {
      playlistsModel.addMediaToPlaylist(media, playlists.id);
      Toast.show(t.mediaaddedtoplaylist, context);
    } else {
      playlistsModel.deleteMediaFromPlaylist(media, playlists.id);
      Toast.show(t.mediaremovedfromplaylist, context);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        initialData: false,
        future: playlistsModel.isMediaAddedToPlaylist(
            media, playlists.id), //returns bool
        builder:
            (BuildContext context, AsyncSnapshot<bool> isAddedToPlaylists) {
          bool isAdded = false;
          if (isAddedToPlaylists.data != null) {
            isAdded = isAddedToPlaylists.data;
          }
          return InkWell(
            child: ListTile(
              //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                width: 40,
                height: 40,
                child: FutureBuilder<String>(
                    initialData: "",
                    future: playlistsModel.getPlayListFirstMediaThumbnail(
                        playlists.id), //returns bool
                    builder:
                        (BuildContext context, AsyncSnapshot<String> value) {
                      if (value.data == null || value.data == "")
                        return Icon(
                          Icons.music_note,
                          size: 30,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                        );
                      else
                        return CachedNetworkImage(
                          imageUrl: value.data,
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
                  future: playlistsModel
                      .getPlaylistMediaCount(playlists.id), //returns bool
                  builder: (BuildContext context, AsyncSnapshot<int> value) {
                    return Text(
                      value.data == null
                          ? "0 item"
                          : value.data.toString() + " item(s)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  }),
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

              //subtitle:  Text(categories.interest, ),
              trailing: Checkbox(
                  value: isAddedToPlaylists.data,
                  onChanged: ((isChecked) {
                    addMediaToPlaylist(context, isAdded);
                  })),
            ),
            onTap: () {
              addMediaToPlaylist(context, isAdded);
            },
          );
        });
  }
}
