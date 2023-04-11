class Playlists {
  final int id;
  final String title;
  final String type;
  final int mediaCount;

  static const String TABLE = "playlists";
  static final columns = ["id", "title", "type"];

  Playlists({this.id, this.title, this.type, this.mediaCount});

  factory Playlists.fromMap(Map<String, dynamic> data) {
    return Playlists(
        id: data['id'],
        title: data['title'],
        type: data['type'],
        mediaCount: 0);
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "type": type, "mediaCount": 0};
}
