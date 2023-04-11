import 'package:flutter/foundation.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';
import '../models/Playlists.dart';
import '../database/SQLiteDbProvider.dart';

class PlaylistsModel with ChangeNotifier {
  Userdata userdata;
  List<Playlists> playlistsList = [];
  List<Media> playlistMedias = [];

  PlaylistsModel() {
    getPlaylists();
  }

  getPlaylists() async {
    playlistsList = await SQLiteDbProvider.db.getAllPlaylists();
    playlistsList.reversed.toList();
    for (var item in playlistsList) {
      print(item.type);
    }
    notifyListeners();
  }

  createPlaylist(String title, String type) async {
    await SQLiteDbProvider.db.newPlaylist(title, type);
    getPlaylists();
  }

  deletePlaylists(int id) async {
    await SQLiteDbProvider.db.deletePlaylist(id);
    await SQLiteDbProvider.db.deletePlaylistsMedia(id);
    getPlaylists();
  }

  deletePlaylistsMediaList(int id) async {
    await SQLiteDbProvider.db.deletePlaylistsMedia(id);
    getPlaylists();
  }

  Future<bool> isMediaAddedToPlaylist(Media media, int id) async {
    return await SQLiteDbProvider.db.isMediaAddedToPlaylist(media, id);
  }

  Future<String> getPlayListFirstMediaThumbnail(int id) async {
    return await SQLiteDbProvider.db.getPlayListFirstMediaThumbnail(id);
  }

  Future<int> getPlaylistMediaCount(int id) async {
    return await SQLiteDbProvider.db.getPlaylistsMediaCount(id);
  }

  addMediaToPlaylist(Media media, int id) async {
    await SQLiteDbProvider.db.addMediaToPlaylists(media, id);
    getPlaylists();
  }

  deleteMediaFromPlaylist(Media media, int id) async {
    await SQLiteDbProvider.db.removeMediaFromPlaylist(media, id);
    getPlaylists();
  }

  Future<List<Media>> getPlaylistsMedia(int id) async {
    return await SQLiteDbProvider.db.getAllPlaylistsMedia(id);
  }
}
