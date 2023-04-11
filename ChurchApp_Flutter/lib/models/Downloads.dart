import 'package:flutter_downloader/flutter_downloader.dart';
import '../models/Media.dart';

class Downloads {
  final int id;
  int commentsCount, likesCount, previewDuration, duration, viewsCount;
  final String category, title, coverPhoto, mediaType, videoType;
  final String description;
  String downloadUrl, streamUrl;
  final bool canPreview, canDownload, isFree, http;
  bool userLiked;
  int progress = 0;
  int timeStamp = 0;
  String taskId = "";
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  Downloads(
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
      this.timeStamp,
      this.progress,
      this.taskId,
      this.commentsCount,
      this.likesCount,
      this.previewDuration,
      this.streamUrl,
      this.viewsCount});

  static const String Downloads_TABLE = "downloads";
  static final downloadscolumns = [
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
    "timeStamp",
    "progress",
    "taskId",
    "commentsCount",
    "likesCount",
    "previewDuration",
    "streamUrl",
    "viewsCount"
  ];

  factory Downloads.fromMap(Map<String, dynamic> data) {
    return Downloads(
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
        timeStamp: data['timeStamp'],
        progress: data['progress'],
        taskId: data['taskId'],
        commentsCount: data['commentsCount'],
        likesCount: data['likesCount'],
        previewDuration: data['previewDuration'],
        streamUrl: data['streamUrl'],
        viewsCount: data['viewsCount']);
  }

  static mapCurrentDownloadMedia(Media media) {
    return Downloads(
      id: media.id,
      category: media.category,
      title: media.title,
      coverPhoto: media.coverPhoto,
      mediaType: media.mediaType,
      videoType: media.videoType,
      description: media.description,
      downloadUrl: media.streamUrl,
      canPreview: true,
      canDownload: false,
      isFree: true,
      userLiked: media.userLiked,
      http: false,
      duration: media.duration,
      timeStamp: new DateTime.now().microsecondsSinceEpoch,
      progress: 0,
      taskId: "",
      commentsCount: media.commentsCount,
      likesCount: media.likesCount,
      previewDuration: media.previewDuration,
      streamUrl: media.streamUrl,
      viewsCount: media.viewsCount,
    );
  }

  static Media mapMediaFromDownload(Downloads media) {
    return Media(
      id: media.id,
      category: media.category,
      title: media.title,
      coverPhoto: media.coverPhoto,
      mediaType: media.mediaType,
      videoType: media.videoType,
      description: media.description,
      downloadUrl: media.downloadUrl,
      canPreview: true,
      canDownload: false,
      isFree: true,
      userLiked: media.userLiked,
      http: false,
      duration: media.duration,
      commentsCount: media.commentsCount,
      likesCount: media.likesCount,
      previewDuration: media.previewDuration,
      streamUrl: media.streamUrl,
      viewsCount: media.viewsCount,
    );
  }

  static List<Media> mapMediaListFromDownloadList(
      List<Downloads> downloadsList) {
    List<Media> mediaList = [];
    for (var media in downloadsList) {
      mediaList.add(Media(
        id: media.id,
        category: media.category,
        title: media.title,
        coverPhoto: media.coverPhoto,
        mediaType: media.mediaType,
        videoType: media.videoType,
        description: media.description,
        downloadUrl: media.downloadUrl,
        canPreview: true,
        canDownload: false,
        isFree: true,
        userLiked: media.userLiked,
        http: false,
        duration: media.duration,
        commentsCount: media.commentsCount,
        likesCount: media.likesCount,
        previewDuration: media.previewDuration,
        streamUrl: media.streamUrl,
        viewsCount: media.viewsCount,
      ));
    }
    return mediaList;
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
        "timeStamp": duration,
        "progress": duration,
        "taskId": taskId,
        "commentsCount": commentsCount,
        "likesCount": likesCount,
        "preview_duration": previewDuration,
        "streamUrl": streamUrl,
        "viewsCount": viewsCount
      };
}
