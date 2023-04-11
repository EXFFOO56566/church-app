class Branches {
  final int id;
  final String name, address;
  final String pastor, phone, email;

  Branches(
      {this.id, this.name, this.address, this.pastor, this.phone, this.email});

  factory Branches.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Branches(
      id: id,
      name: json['name'] as String,
      address: json['address'] as String,
      pastor: json['pastor'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
    );
  }
}
