class Media {
  final int id;
  int commentsCount, likesCount, previewDuration, duration, viewsCount;
  final String category, title, coverPhoto, mediaType, videoType;
  final String description, downloadUrl, streamUrl;
  final bool canPreview, canDownload, isFree, http;
  bool userLiked;

  Media(
      {this.id,
      this.category,
      this.title,
      this.coverPhoto,
      this.mediaType,
      this.videoType,
      this.description,
      this.downloadUrl,
      this.canPreview,
      this.canDownload,
      this.isFree,
      this.userLiked,
      this.http,
      this.duration,
      this.commentsCount,
      this.likesCount,
      this.previewDuration,
      this.streamUrl,
      this.viewsCount});

  static const String BOOKMARKS_TABLE = "bookmarks";
  static const String PLAYLISTS_TABLE = "media_playlists";
  static final bookmarkscolumns = [
    "id",
    "category",
    "title",
    "coverPhoto",
    "mediaType",
    "videoType",
    "description",
    "downloadUrl",
    "canPreview",
    "canDownload",
    "isFree",
    "userLiked",
    "http",
    "duration",
    "commentsCount",
    "likesCount",
    "previewDuration",
    "streamUrl",
    "viewsCount"
  ];
  static final playlistscolumns = [
    "id",
    "playlistId",
    "category",
    "title",
    "coverPhoto",
    "mediaType",
    "videoType",
    "description",
    "downloadUrl",
    "canPreview",
    "canDownload",
    "isFree",
    "userLiked",
    "http",
    "duration",
    "commentsCount",
    "likesCount",
    "previewDuration",
    "streamUrl",
    "viewsCount"
  ];

  factory Media.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Media(
        id: id,
        category: json['category'] as String,
        title: json['title'] as String,
        coverPhoto: json['cover_photo'] as String,
        mediaType: json['type'] as String,
        videoType: json['video_type'] as String,
        description: json['description'] as String,
        downloadUrl: json['download_url'] as String,
        canPreview: int.parse(json['can_preview'].toString()) == 0,
        canDownload: int.parse(json['can_download'].toString()) == 0,
        isFree: int.parse(json['is_free'].toString()) == 0,
        userLiked:
            bool.fromEnvironment(json['user_liked'].toString().toLowerCase()),
        http: true,
        duration: int.parse(json['duration'].toString()),
        commentsCount: int.parse(json['comments_count'].toString()),
        likesCount: int.parse(json['likes_count'].toString()),
        previewDuration: int.parse(json['preview_duration'].toString()),
        streamUrl: json['stream'] as String,
        viewsCount: int.parse(json['views_count'].toString()));
  }

  factory Media.fromMap(Map<String, dynamic> data) {
    return Media(
        id: data['id'],
        category: data['category'],
        title: data['title'],
        coverPhoto: data['coverPhoto'],
        mediaType: data['mediaType'],
        videoType: data['videoType'],
        description: data['description'],
        downloadUrl: data['downloadUrl'],
        canPreview: int.parse(data['canPreview'].toString()) == 0,
        canDownload: int.parse(data['canDownload'].toString()) == 0,
        isFree: int.parse(data['isFree'].toString()) == 0,
        userLiked: int.parse(data['userLiked'].toString()) == 0,
        http: int.parse(data['http'].toString()) == 0,
        duration: data['duration'],
        commentsCount: data['commentsCount'],
        likesCount: data['likesCount'],
        previewDuration: data['previewDuration'],
        streamUrl: data['streamUrl'],
        viewsCount: data['viewsCount']);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "category": category,
        "title": title,
        "coverPhoto": coverPhoto,
        "mediaType": mediaType,
        "videoType": videoType,
        "description": description,
        "downloadUrl": downloadUrl,
        "canPreview": canPreview,
        "canDownload": canDownload,
        "isFree": isFree,
        "userLiked": userLiked,
        "http": http,
        "duration": duration,
        "commentsCount": commentsCount,
        "likesCount": likesCount,
        "previewDuration": previewDuration,
        "streamUrl": streamUrl,
        "viewsCount": viewsCount
      };
}
