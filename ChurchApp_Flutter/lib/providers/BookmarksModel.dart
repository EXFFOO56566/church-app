import 'package:flutter/foundation.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';
import '../database/SQLiteDbProvider.dart';

class BookmarksModel with ChangeNotifier {
  Userdata userdata;
  List<Media> bookmarksList = [];

  BookmarksModel() {
    getBookmarks();
  }

  getBookmarks() async {
    bookmarksList = await SQLiteDbProvider.db.getAllMediaBookmarks();
    //bookmarksList.reversed.toList();
    notifyListeners();
    print(bookmarksList.length.toString());
  }

  bookmarkMedia(Media media) async {
    await SQLiteDbProvider.db.bookmarkMedia(media);
    getBookmarks();
  }

  unBookmarkMedia(Media media) async {
    await SQLiteDbProvider.db.deleteBookmarkedMedia(media.id);
    getBookmarks();
  }

  bool isMediaBookmarked(Media media) {
    Media itm = bookmarksList.firstWhere((itm) => itm.id == media.id,
        orElse: () => null);
    return itm != null;
  }
}
