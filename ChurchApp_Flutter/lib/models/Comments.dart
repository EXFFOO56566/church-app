class Comments {
  final int id, mediaId, date, replies, edited;
  final String email, name, avatar, coverPhoto;
  String content;

  Comments({
    this.id,
    this.mediaId,
    this.email,
    this.name,
    this.content,
    this.date,
    this.replies,
    this.edited,
    this.avatar,
    this.coverPhoto,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int mediaId = int.parse(json['media_id'].toString());
    int date = int.parse(json['date'].toString());
    int replies = int.parse(json['replies'].toString());
    int edited = int.parse(json['edited'].toString());
    return Comments(
      id: id,
      email: json['email'] as String,
      name: json['name'] as String,
      content: json['content'] as String,
      date: date,
      mediaId: mediaId,
      replies: replies,
      edited: edited,
      avatar: json['avatar'] as String,
      coverPhoto: json['cover_photo'] as String,
    );
  }

  factory Comments.fromJson2(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int mediaId = int.parse(json['post_id'].toString());
    int date = int.parse(json['date'].toString());
    int replies = int.parse(json['replies'].toString());
    int edited = int.parse(json['edited'].toString());
    return Comments(
      id: id,
      email: json['email'] as String,
      name: json['name'] as String,
      content: json['content'] as String,
      date: date,
      mediaId: mediaId,
      replies: replies,
      edited: edited,
      avatar: json['avatar'] as String,
      coverPhoto: json['cover_photo'] as String,
    );
  }

  factory Comments.fromMap(Map<String, dynamic> data) {
    return Comments(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      content: data['thumbnail'],
      date: data['date'],
      mediaId: data['media_id'],
      replies: data['replies'],
      edited: data['edited'],
      avatar: data['avatar'],
      coverPhoto: data['coverPhoto'],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "content": content,
        "date": date,
        "mediaId": mediaId,
        "replies": replies,
        "edited": edited,
        "avatar": avatar,
        "coverPhoto": coverPhoto,
      };
}
