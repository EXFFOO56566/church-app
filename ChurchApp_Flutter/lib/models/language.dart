class Language {
  String name;
  String code;
  bool isRecent;
  bool isDownloaded;
  bool isDownloadable;

  Language(String code, String name, bool isRecent, bool isDownloaded,
      bool isDownloadable) {
    this.name = name;
    this.code = code;
    this.isRecent = isRecent;
    this.isDownloaded = isDownloaded;
    this.isDownloadable = isDownloadable;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'isRecent': isRecent,
        'isDownloaded': isDownloaded,
        'isDownloadable': isDownloadable,
      };

  Language.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        code = json['code'],
        isRecent = json['isRecent'],
        isDownloaded = json['isDownloaded'],
        isDownloadable = json['isDownloadable'];
}
