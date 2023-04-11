class Versions {
  final int id;
  final String name, code;
  final String description, source;

  Versions({this.id, this.name, this.code, this.description, this.source});
  static const String TABLE = "versions";
  static final columns = ["id", "name", "code", "description"];

  factory Versions.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Versions(
        id: id,
        name: json['name'] as String,
        code: json['shortcode'] as String,
        description: json['description'] as String,
        source: json['source'] as String);
  }

  factory Versions.fromMap(Map<String, dynamic> data) {
    return Versions(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        code: data['code'],
        source: "");
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "code": code,
        "description": description,
        source: ""
      };
}
