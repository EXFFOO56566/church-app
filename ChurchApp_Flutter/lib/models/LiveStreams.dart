class LiveStreams {
  final int id;
  final String title, description, streamUrl, type;

  LiveStreams(
      {this.id, this.title, this.type, this.description, this.streamUrl});

  factory LiveStreams.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return LiveStreams(
        id: id,
        title: json['title'] as String,
        type: json['type'] as String,
        description: json['description'] as String,
        streamUrl: json['stream_url'] as String);
  }
}
