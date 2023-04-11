class Events {
  final int id;
  final String title, thumbnail;
  final String details, time, date;

  Events(
      {this.id,
      this.title,
      this.thumbnail,
      this.details,
      this.time,
      this.date});

  factory Events.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Events(
        id: id,
        title: json['title'] as String,
        thumbnail: json['thumbnail'] as String,
        details: json['details'] as String,
        time: json['time'] as String,
        date: json['date'] as String);
  }
}
