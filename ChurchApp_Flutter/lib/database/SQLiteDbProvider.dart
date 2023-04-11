import 'dart:async';
import '../models/Categories.dart';
import '../models/Userdata.dart';
import 'package:path/path.dart';
import '../models/Versions.dart';
import '../models/Bible.dart';
import '../models/Hymns.dart';
import '../models/Media.dart';
import '../models/Playlists.dart';
import '../models/Notes.dart';
import '../models/Downloads.dart';
import '../utils/StringsUtils.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'streamit_database.db'),
        version: 1,
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${Categories.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "thumbnailUrl TEXT"
          ")");

      await db.execute("CREATE TABLE ${Versions.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "code TEXT,"
          "description TEXT"
          ")");

      await db.execute("CREATE TABLE ${Bible.TABLE} ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "book TEXT,"
          "chapter INTEGER,"
          "verse INTEGER,"
          "content TEXT,"
          "version TEXT"
          ")");

      await db.execute("CREATE TABLE ${Bible.COLORED_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "book TEXT,"
          "chapter INTEGER,"
          "verse INTEGER,"
          "content TEXT,"
          "version TEXT,"
          "color INTEGER,"
          "date INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Hymns.BOOKMARKS_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "thumbnail TEXT,"
          "content TEXT"
          ")");

      await db.execute("CREATE TABLE ${Notes.TABLE} ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT,"
          "content TEXT,"
          "date INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Playlists.TABLE} ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT,"
          "type TEXT"
          ")");

      await db.execute("CREATE TABLE ${Media.BOOKMARKS_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "category TEXT,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "videoType TEXT,"
          "description TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Media.PLAYLISTS_TABLE} ("
          "id INTEGER,"
          "playlistId INTEGER,"
          "category TEXT,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "videoType TEXT,"
          "description TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Downloads.Downloads_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "category TEXT,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "videoType TEXT,"
          "description TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "timeStamp INTEGER,"
          "progress INTEGER,"
          "taskId TEXT,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Userdata.TABLE} ("
          "email TEXT,"
          "name TEXT,"
          "coverPhoto TEXT,"
          "avatar TEXT,"
          "gender TEXT,"
          "dateOfBirth TEXT,"
          "phone TEXT,"
          "aboutMe TEXT,"
          "location TEXT,"
          "qualification TEXT,"
          "facebook TEXT,"
          "twitter TEXT,"
          "linkdln TEXT,"
          "activated INTEGER"
          ")");
    });
  }

  //userdata crud
  Future<Userdata> getUserData() async {
    final db = await database;
    List<Map> results = await db.query(
      "${Userdata.TABLE}",
      columns: Userdata.columns,
    );
    print(results.toString());
    List<Userdata> userdatalist = [];
    results.forEach((result) {
      Userdata userdata = Userdata.fromMap(result);
      userdatalist.add(userdata);
    });
    //print(categories.length);
    return userdatalist.length > 0 ? userdatalist[0] : null;
  }

  insertUser(Userdata userdata) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into ${Userdata.TABLE} (email, name,coverPhoto, avatar,gender,dateOfBirth,phone,aboutMe,location,qualification,facebook,twitter,linkdln,activated)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          userdata.email,
          userdata.name,
          userdata.coverPhoto,
          userdata.avatar,
          userdata.gender,
          userdata.dateOfBirth,
          userdata.phone,
          userdata.aboutMe,
          userdata.location,
          userdata.qualification,
          userdata.facebook,
          userdata.twitter,
          userdata.linkdln,
          userdata.activated
        ]);
    return result;
  }

  deleteUserData() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${Userdata.TABLE}");
  }

  //categories crud
  Future<List<Categories>> getAllCategories() async {
    final db = await database;
    List<Map> results = await db.query("${Categories.TABLE}",
        columns: Categories.columns, orderBy: "id ASC");
    List<Categories> categories = [];
    results.forEach((result) {
      Categories category = Categories.fromMap(result);
      categories.add(category);
    });
    //print(categories.length);
    return categories;
  }

  insertCategory(Categories categories) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Categories.TABLE} (id, title, thumbnailUrl)"
        " VALUES (?, ?, ?)",
        [categories.id, categories.title, categories.thumbnailUrl]);
    return result;
  }

  deleteCategory(int id) async {
    final db = await database;
    db.delete("${Categories.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //media bookmarks crud
  Future<List<Media>> getAllMediaBookmarks() async {
    final db = await database;
    List<Map> results = await db.query("${Media.BOOKMARKS_TABLE}",
        columns: Media.bookmarkscolumns);
    List<Media> medialist = [];
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  bookmarkMedia(Media media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Media.BOOKMARKS_TABLE} (id,category,title,coverPhoto,mediaType,videoType,description,downloadUrl,canPreview,canDownload,isFree,userLiked,http, duration,commentsCount,likesCount,previewDuration,streamUrl,viewsCount)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          media.id,
          media.category,
          media.title,
          media.coverPhoto,
          media.mediaType,
          media.videoType,
          media.description,
          media.downloadUrl,
          media.canPreview == true ? 0 : 1,
          media.canDownload == true ? 0 : 1,
          media.isFree == true ? 0 : 1,
          media.userLiked == true ? 0 : 1,
          media.http == true ? 0 : 1,
          media.duration,
          media.commentsCount,
          media.likesCount,
          media.previewDuration,
          media.streamUrl,
          media.viewsCount
        ]);
    return result;
  }

  //userdata crud
  Future<bool> isMediaBookmarked(Media media) async {
    final db = await database;
    List<Map> results = await db.query("${Media.BOOKMARKS_TABLE}",
        columns: Media.bookmarkscolumns,
        where: "id = ?",
        whereArgs: [media.id]);
    return results.length > 0;
  }

  deleteBookmarkedMedia(int id) async {
    final db = await database;
    db.delete("${Media.BOOKMARKS_TABLE}", where: "id = ?", whereArgs: [id]);
  }

//playlists crud
  Future<List<Playlists>> getAllPlaylists() async {
    final db = await database;
    List<Map> results =
        await db.query("${Playlists.TABLE}", columns: Playlists.columns);
    List<Playlists> playlists = [];
    results.forEach((result) {
      Playlists playlist = Playlists.fromMap(result);
      playlists.add(playlist);
    });
    //print(categories.length);
    return playlists;
  }

  newPlaylist(String title, String type) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Playlists.TABLE} (title, type)"
        " VALUES (?, ?)",
        [title, type]);
    return result;
  }

  deletePlaylist(int id) async {
    final db = await database;
    db.delete("${Playlists.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //media playlists crud
  Future<List<Media>> getAllPlaylistsMedia(int playlistid) async {
    final db = await database;
    List<Map> results = await db.query("${Media.PLAYLISTS_TABLE}",
        columns: Media.playlistscolumns,
        where: "playlistId = ?",
        whereArgs: [playlistid]);
    List<Media> medialist = [];
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  Future<int> getPlaylistsMediaCount(int playlistid) async {
    final db = await database;
    List<Map> results = await db.query("${Media.PLAYLISTS_TABLE}",
        columns: Media.playlistscolumns,
        where: "playlistId = ?",
        whereArgs: [playlistid]);
    List<Media> medialist = [];
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist.length;
  }

  Future<String> getPlayListFirstMediaThumbnail(int playlistid) async {
    final db = await database;
    List<Map> results = await db.query("${Media.PLAYLISTS_TABLE}",
        columns: Media.playlistscolumns,
        where: "playlistId = ?",
        whereArgs: [playlistid]);
    List<Media> medialist = [];
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    if (medialist.length > 0) {
      return medialist[0].coverPhoto;
    }
    //print(categories.length);
    return "";
  }

  addMediaToPlaylists(Media media, int playlistid) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Media.PLAYLISTS_TABLE} (id, playlistId,category,title,coverPhoto,mediaType,videoType,description,downloadUrl,canPreview,canDownload,isFree,userLiked,http, duration,commentsCount,likesCount,previewDuration,streamUrl,viewsCount)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          media.id,
          playlistid,
          media.category,
          media.title,
          media.coverPhoto,
          media.mediaType,
          media.videoType,
          media.description,
          media.downloadUrl,
          media.canPreview == true ? 0 : 1,
          media.canDownload == true ? 0 : 1,
          media.isFree == true ? 0 : 1,
          media.userLiked == true ? 0 : 1,
          media.http == true ? 0 : 1,
          media.duration,
          media.commentsCount,
          media.likesCount,
          media.previewDuration,
          media.streamUrl,
          media.viewsCount
        ]);
    return result;
  }

  //userdata crud
  Future<bool> isMediaAddedToPlaylist(Media media, int playlistid) async {
    final db = await database;
    List<Map> results = await db.query("${Media.PLAYLISTS_TABLE}",
        columns: Media.playlistscolumns,
        where: "id = ? AND playlistId = ?",
        whereArgs: [media.id, playlistid]);
    return results.length > 0;
  }

  deletePlaylistsMedia(int playlistid) async {
    final db = await database;
    db.delete("${Media.PLAYLISTS_TABLE}",
        where: "playlistId = ?", whereArgs: [playlistid]);
  }

  removeMediaFromPlaylist(Media media, int playlistid) async {
    final db = await database;
    db.delete("${Media.PLAYLISTS_TABLE}",
        where: "id = ? AND playlistId = ?", whereArgs: [media.id, playlistid]);
  }

  //downloads list crud
  Future<List<Downloads>> getAllDownloads() async {
    final db = await database;
    List<Map> results = await db.query("${Downloads.Downloads_TABLE}",
        columns: Downloads.downloadscolumns, orderBy: "timeStamp Desc");
    List<Downloads> medialist = [];
    results.forEach((result) {
      Downloads media = Downloads.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  addNewDownloadItem(Downloads media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR IGNORE Into ${Downloads.Downloads_TABLE} (id,category,title,coverPhoto,mediaType,videoType,description,downloadUrl,canPreview,canDownload,isFree,userLiked,http, duration,timeStamp,progress,taskId,commentsCount,likesCount,previewDuration,streamUrl,viewsCount)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          media.id,
          media.category,
          media.title,
          media.coverPhoto,
          media.mediaType,
          media.videoType,
          media.description,
          media.downloadUrl,
          media.canPreview == true ? 0 : 1,
          media.canDownload == true ? 0 : 1,
          media.isFree == true ? 0 : 1,
          media.userLiked == true ? 0 : 1,
          media.http == true ? 0 : 1,
          media.duration,
          media.timeStamp,
          media.progress,
          media.taskId,
          media.commentsCount,
          media.likesCount,
          media.previewDuration,
          media.streamUrl,
          media.viewsCount
        ]);
    return result;
  }

  deleteDownloadMedia(int id) async {
    final db = await database;
    db.delete("${Downloads.Downloads_TABLE}", where: "id = ?", whereArgs: [id]);
  }

  ////Hymns bookmarks
  Future<List<Hymns>> getAllBookmarkedHymns() async {
    final db = await database;
    List<Map> results = await db.query("${Hymns.BOOKMARKS_TABLE}",
        columns: Hymns.bookmarkscolumns);
    List<Hymns> medialist = [];
    results.forEach((result) {
      Hymns media = Hymns.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  bookmarkHymn(Hymns hymns) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Hymns.BOOKMARKS_TABLE} (id,title,thumbnail,content)"
        " VALUES (?, ?, ?, ?)",
        [hymns.id, hymns.title, hymns.thumbnail, hymns.content]);
    return result;
  }

  //userdata crud
  Future<bool> isHymnBookmarked(Hymns hymns) async {
    final db = await database;
    List<Map> results = await db.query("${Hymns.BOOKMARKS_TABLE}",
        columns: Hymns.bookmarkscolumns,
        where: "id = ?",
        whereArgs: [hymns.id]);
    return results.length > 0;
  }

  deleteBookmarkedHymn(int id) async {
    final db = await database;
    db.delete("${Hymns.BOOKMARKS_TABLE}", where: "id = ?", whereArgs: [id]);
  }

  ////Notes CRUD
  Future<List<Notes>> getAllNotes() async {
    final db = await database;
    List<Map> results = await db.query("${Notes.TABLE}",
        columns: Notes.tableColumns, orderBy: "date DESC");
    List<Notes> noteslist = [];
    results.forEach((result) {
      Notes notes = Notes.fromMap(result);
      noteslist.add(notes);
    });
    //print(categories.length);
    return noteslist;
  }

  saveNote(Notes notes) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Notes.TABLE} (id,title,content,date)"
        " VALUES (?, ?, ?, ?)",
        [notes.id, notes.title, notes.content, notes.date]);
    return result;
  }

  deleteNote(int id) async {
    final db = await database;
    db.delete("${Notes.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //bible versions crud
  Future<List<Versions>> getAllBibleVersions() async {
    final db = await database;
    List<Map> results = await db.query("${Versions.TABLE}",
        columns: Versions.columns, orderBy: "id ASC");
    List<Versions> versionsList = [];
    results.forEach((result) {
      Versions versions = Versions.fromMap(result);
      versionsList.add(versions);
    });
    //print(categories.length);
    return versionsList;
  }

  insertBibleVersion(Versions versions) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Versions.TABLE} (id, name, code, description)"
        " VALUES (?, ?, ?, ?)",
        [versions.id, versions.name, versions.code, versions.description]);
    return result;
  }

  //bible crud
  insertBible(Bible bible) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Bible.TABLE} (book, chapter, verse, content, version)"
        " VALUES (?, ?, ?, ?, ?)",
        [bible.book, bible.chapter, bible.verse, bible.content, bible.version]);
    return result;
  }

  insertBatchBible(List<Bible> bibleList) async {
    final db = await database;
    Batch batch = db.batch();
    bibleList.forEach((bible) {
      batch.insert(Bible.TABLE, bible.toMap());
    });
    await batch.commit(noResult: true);
  }

  insertBatchColoredBible(List<Bible> bibleList) async {
    final db = await database;
    // db.execute("DELETE FROM " + Bible.COLORED_TABLE);
    Batch batch = db.batch();
    bibleList.forEach((bible) {
      batch.insert(Bible.COLORED_TABLE, bible.toColoredMap());
    });
    await batch.commit(noResult: true);
  }

  deleteColoredBibleVerse(Bible bible) async {
    final db = await database;
    db.delete("${Bible.COLORED_TABLE}",
        where: "id = ? AND version = ?", whereArgs: [bible.id, bible.version]);
  }

  /* insertBatchBible(List<Bible> bibleList) async {
    final db = await database;
    Batch batch = db.batch();
    Map map = Map();
    map['batch'] = batch;
    map['bibleList'] = bibleList;
    //await batch.commit(noResult: true);
  }*/

  Future<List<Bible>> getAllBible(
      String version, String book, int chapter) async {
    final db = await database;
    List<Map> results = await db.query("${Bible.TABLE}",
        columns: Bible.columns,
        where: 'version = ? AND book = ? AND chapter = ?',
        whereArgs: [version, book, chapter],
        orderBy: "id ASC");
    List<Bible> bibleList = [];
    results.forEach((result) {
      Bible bible = Bible.fromMap(result);
      bibleList.add(bible);
    });
    //print(categories.length);
    return bibleList;
  }

  Future<List<Bible>> getAllColoredVerses() async {
    final db = await database;
    List<Map> results = await db.query("${Bible.COLORED_TABLE}",
        columns: Bible.coloredcolumns, orderBy: "date DESC");
    List<Bible> bibleList = [];
    results.forEach((result) {
      Bible bible = Bible.fromCOloredMap(result);
      bibleList.add(bible);
    });
    //print(categories.length);
    return bibleList;
  }

  Future<List<Bible>> searchColoredBibleVerses(String query) async {
    final db = await database;
    List<Map> results = await db.query(
      "${Bible.COLORED_TABLE}",
      columns: Bible.coloredcolumns,
      where: "content LIKE '%$query%'",
      orderBy: "date DESC",
    );
    List<Bible> bibleList = [];
    results.forEach((result) {
      Bible bible = Bible.fromCOloredMap(result);
      bibleList.add(bible);
    });
    //print(categories.length);
    return bibleList;
  }

  Future<List<Bible>> filterColoredVersesByColor(int color) async {
    final db = await database;
    List<Map> results = await db.query(
      "${Bible.COLORED_TABLE}",
      columns: Bible.coloredcolumns,
      where: "color = ?",
      whereArgs: [color],
      orderBy: "date DESC",
    );
    List<Bible> bibleList = [];
    results.forEach((result) {
      Bible bible = Bible.fromCOloredMap(result);
      bibleList.add(bible);
    });
    //print(categories.length);
    return bibleList;
  }

  Future<List<Bible>> searchBible(String query, String version, String book,
      bool oldtestament, bool newtestament, int limit) async {
    final db = await database;
    List<Map> results;
    if (book != "") {
      results = await db.query(
        "${Bible.TABLE}",
        columns: Bible.columns,
        where: "content LIKE '%$query%' AND version = ? AND book = ? ",
        whereArgs: [version, book],
        orderBy: "id ASC",
        limit: limit,
      );
    } else {
      List<String> books = StringsUtils.bibleBooks;
      if (oldtestament && !newtestament) {
        books = StringsUtils.oldtestaments;
      } else if (!oldtestament && newtestament) {
        books = StringsUtils.newtestaments;
      }

      var select =
          'SELECT * from biblebooks WHERE content LIKE ? AND version = ? AND book IN (\'' +
              (books.join('\',\'')).toString() +
              '\') ORDER BY id ASC LIMIT $limit';

      results = await db.rawQuery(select, ['%$query%', version]);
    }
    List<Bible> bibleList = [];
    results.forEach((result) {
      Bible bible = Bible.fromMap(result);
      bibleList.add(bible);
    });
    //print(categories.length);
    return bibleList;
  }

  Future<List<Bible>> getAllBibleByVerse(
      String version, String book, int chapter, int verse) async {
    final db = await database;
    List<Map> results = await db.query("${Bible.TABLE}",
        columns: Bible.columns,
        where: 'book = ? AND chapter = ? AND verse = ?',
        whereArgs: [book, chapter, verse],
        orderBy: "id ASC");
    List<Bible> bibleList = [];
    results.forEach((result) {
      Bible bible = Bible.fromMap(result);
      bibleList.add(bible);
    });
    //print(categories.length);
    return bibleList;
  }
}

// A function to loop and insert bibles in the background
/*batchinsertbible(List<Bible> bibleList) async {
  Database db = await SQLiteDbProvider.db.database;
  db.transaction((txn) async {
    Batch batch = txn.batch();
    bibleList.forEach((bible) {
      batch.insert(Bible.TABLE, bible.toMap());
    });
    batch.commit();
  });
}*/
