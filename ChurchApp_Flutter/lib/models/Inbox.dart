class Inbox {
  final int id;
  final String title, message;
  final int date;

  Inbox({this.id, this.title, this.message, this.date});

  factory Inbox.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int date = int.parse(json['date'].toString());
    return Inbox(
        id: id,
        title: json['title'] as String,
        message: json['message'] as String,
        date: date);
  }
}
