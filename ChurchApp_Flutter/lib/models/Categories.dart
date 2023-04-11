class Categories {
  final int id;
  final String title;
  final String thumbnailUrl;
  final int mediaCount;

  static const String TABLE = "categories";
  static final columns = ["id", "title", "thumbnailUrl", "mediaCount"];

  Categories({this.id, this.title, this.thumbnailUrl, this.mediaCount});

  factory Categories.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int count = int.parse(json['media_count'].toString());
    return Categories(
      id: id,
      title: json['name'] as String,
      thumbnailUrl: json['thumbnail'] as String,
      mediaCount: count,
    );
  }

  factory Categories.fromJson2(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Categories(
      id: id,
      title: json['name'] as String,
      thumbnailUrl: "",
      mediaCount: 0,
    );
  }

  factory Categories.fromMap(Map<String, dynamic> data) {
    return Categories(
        id: data['id'],
        title: data['title'],
        thumbnailUrl: data['thumbnailUrl'],
        mediaCount: data['mediaCount']);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "thumbnailUrl": thumbnailUrl,
        "mediaCount": mediaCount
      };
}
