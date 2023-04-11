class Hymns {
  final int id;
  final String title, thumbnail, content;

  Hymns({this.id, this.title, this.thumbnail, this.content});

  static const String BOOKMARKS_TABLE = "hymnsbookmarks";
  static final bookmarkscolumns = ["id", "title", "thumbnail", "content"];

  factory Hymns.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Hymns(
        id: id,
        title: json['title'] as String,
        thumbnail: json['thumbnail'] as String,
        content: json['content'] as String);
  }

  factory Hymns.fromMap(Map<String, dynamic> data) {
    return Hymns(
        id: data['id'],
        title: data['title'],
        thumbnail: data['thumbnail'],
        content: data['content']);
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "thumbnail": thumbnail, "content": content};
}
