class Bible {
  final int id;
  final String book;
  final int verse, chapter;
  final String content;
  final String version;
  int color = 0;
  int date = 0;

  Bible(
      {this.id,
      this.book,
      this.chapter,
      this.verse,
      this.content,
      this.version,
      this.color = 0,
      this.date = 0});
  static const String TABLE = "biblebooks";
  static const String COLORED_TABLE = "coloredbiblebooks";
  static final columns = [
    "id",
    "book",
    "chapter",
    "verse",
    "content",
    "version"
  ];
  static final coloredcolumns = [
    "id",
    "book",
    "chapter",
    "verse",
    "content",
    "version",
    "color",
    "date"
  ];

  factory Bible.fromJson(Map<String, dynamic> json, String version) {
    //print(json);
    int verse = int.parse(json['verse'].toString());
    int chapter = int.parse(json['chapter'].toString());
    return Bible(
        book: json['book'] as String,
        chapter: chapter,
        verse: verse,
        content: json['content'] as String,
        version: version);
  }

  factory Bible.fromMap(Map<String, dynamic> data) {
    return Bible(
      id: data['id'],
      book: data['book'],
      chapter: data['chapter'],
      verse: data['verse'],
      content: data['content'],
      version: data['version'],
    );
  }

  Map<String, dynamic> toMap() => {
        "book": book,
        "chapter": chapter,
        "verse": verse,
        "content": content,
        "version": version
      };

  factory Bible.fromCOloredMap(Map<String, dynamic> data) {
    return Bible(
      id: data['id'],
      book: data['book'],
      chapter: data['chapter'],
      verse: data['verse'],
      content: data['content'],
      version: data['version'],
      color: data['color'],
      date: data['date'],
    );
  }

  Map<String, dynamic> toColoredMap() => {
        "id": id,
        "book": book,
        "chapter": chapter,
        "verse": verse,
        "content": content,
        "version": version,
        "color": color,
        "date": date
      };
}
