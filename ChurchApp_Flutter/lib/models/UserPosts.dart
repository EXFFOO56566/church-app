class UserPosts {
  int id = 0;
  int userId = 0;
  String email = "";
  String name = "";
  String avatar = "", coverPhoto = "", content = "";
  String type = "";
  int timestamp = 1, commentsCount = 0, likesCount = 0, edited = 0;
  bool isLiked = false, isPinned = false;
  List<dynamic> media = [];

  UserPosts({
    this.id,
    this.userId,
    this.email,
    this.name,
    this.coverPhoto,
    this.avatar,
    this.content,
    this.type,
    this.timestamp,
    this.commentsCount,
    this.likesCount,
    this.edited,
    this.isLiked,
    this.isPinned,
    this.media,
  });

  factory UserPosts.fromJson(Map<String, dynamic> json) {
    //print(jsonDecode(json['media']));
    int id = int.parse(json['id'].toString());
    int userId = int.parse(json['userId'].toString());
    int timestamp = int.parse(json['timestamp'].toString());
    int commentsCount = int.parse(json['comments_count'].toString());
    int likesCount = int.parse(json['likes_count'].toString());
    int edited = int.parse(json['edited'].toString());
    //print(json);
    return UserPosts(
      id: id,
      userId: userId,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      coverPhoto: json['cover_photo'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      timestamp: timestamp,
      commentsCount: commentsCount,
      likesCount: likesCount,
      isLiked: json['isLiked'] as bool,
      isPinned: json['isPinned'] as bool,
      edited: edited,
      media: json['media'] as List,
    );
  }

  factory UserPosts.fromJson2(Map<String, dynamic> json) {
    //print(jsonDecode(json['media']));
    int id = int.parse(json['id'].toString());
    int userId = int.parse(json['userId'].toString());
    int timestamp = int.parse(json['timestamp'].toString());
    int commentsCount = int.parse(json['comments_count'].toString());
    int likesCount = int.parse(json['likes_count'].toString());
    int edited = int.parse(json['edited'].toString());
    //print(json);
    return UserPosts(
      id: id,
      userId: userId,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      coverPhoto: json['cover_photo'] as String,
      content: json['fluttercontent'] as String,
      type: json['type'] as String,
      timestamp: timestamp,
      commentsCount: commentsCount,
      likesCount: likesCount,
      isLiked: json['isLiked'] as bool,
      isPinned: json['isPinned'] as bool,
      edited: edited,
      media: json['media'] as List,
    );
  }
}
