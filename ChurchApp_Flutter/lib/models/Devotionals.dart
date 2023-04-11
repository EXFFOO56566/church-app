class Devotionals {
  final int id;
  final String title, thumbnail;
  final String author, content, biblereading, confession, studies;

  Devotionals(
      {this.id,
      this.title,
      this.thumbnail,
      this.author,
      this.content,
      this.biblereading,
      this.confession,
      this.studies});

  factory Devotionals.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Devotionals(
      id: id,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      biblereading: json['bible_reading'] as String,
      confession: json['confession'] as String,
      studies: json['studies'] as String,
    );
  }
}
