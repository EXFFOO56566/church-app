class Userdata {
  String email = "";
  String name = "";
  String avatar = "", coverPhoto = "", gender = "";
  String dateOfBirth = "",
      phone = "",
      aboutMe = "",
      location = "",
      qualification = "",
      facebook = "",
      twitter = "",
      linkdln = "";
  int activated = 1;
  bool following = false;

  static const String TABLE = "userdata";
  static final columns = [
    "email",
    "name",
    "coverPhoto",
    "avatar",
    "gender",
    "dateOfBirth",
    "phone",
    "aboutMe",
    "location",
    "qualification",
    "facebook",
    "twitter",
    "linkdln",
    "activated"
  ];

  Userdata({
    this.email,
    this.name,
    this.coverPhoto,
    this.avatar,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.aboutMe,
    this.location,
    this.qualification,
    this.facebook,
    this.twitter,
    this.linkdln,
    this.activated,
    this.following = false,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    print(json['avatar'].toString());
    int activated = int.parse(json['activated'].toString());
    //print(json);
    return Userdata(
        name: json['name'] as String,
        email: json['email'] as String,
        avatar: activated == 1 ? "" : json['avatar'] as String,
        coverPhoto: activated == 1 ? "" : json['cover_photo'] as String,
        gender: activated == 1 ? "" : json['gender'] as String,
        dateOfBirth: activated == 1 ? "" : json['date_of_birth'] as String,
        phone: activated == 1 ? "" : json['phone'] as String,
        aboutMe: activated == 1 ? "" : json['about_me'] as String,
        location: activated == 1 ? "" : json['location'] as String,
        qualification: activated == 1 ? "" : json['qualification'] as String,
        facebook: activated == 1 ? "" : json['facebook'] as String,
        twitter: activated == 1 ? "" : json['twitter'] as String,
        linkdln: activated == 1 ? "" : json['linkdln'] as String,
        activated: activated);
  }

  factory Userdata.fromFCMJson(Map<String, dynamic> json) {
    print(json['avatar'].toString());
    //print(json);
    return Userdata(
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      coverPhoto: json['cover_photo'] as String,
      gender: "",
      dateOfBirth: "",
      phone: "",
      aboutMe: "",
      location: "",
      qualification: "",
      facebook: "",
      twitter: "",
      linkdln: "",
      activated: 0,
    );
  }

  factory Userdata.fromJsonActivated(Map<String, dynamic> json) {
    //print(json);
    return Userdata(
        name: json['name'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String,
        coverPhoto: json['cover_photo'] as String,
        gender: json['gender'] as String,
        dateOfBirth: json['date_of_birth'] as String,
        phone: json['phone'] as String,
        aboutMe: json['about_me'] as String,
        location: json['location'] as String,
        qualification: json['qualification'] as String,
        facebook: json['facebook'] as String,
        twitter: json['twitter'] as String,
        linkdln: json['linkdln'] as String,
        activated: 0);
  }

  factory Userdata.fromJson2(Map<String, dynamic> json) {
    int following = int.parse(json['following'].toString());
    return Userdata(
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      coverPhoto: json['cover_photo'] as String,
      gender: json['gender'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      phone: json['phone'] as String,
      aboutMe: json['about_me'] as String,
      location: json['location'] as String,
      qualification: json['qualification'] as String,
      facebook: json['facebook'] as String,
      twitter: json['twitter'] as String,
      linkdln: json['linkdln'] as String,
      activated: 0,
      following: following == 0,
    );
  }

  factory Userdata.fromMap(Map<String, dynamic> data) {
    return Userdata(
      name: data['name'],
      email: data['email'],
      avatar: data['avatar'],
      coverPhoto: data['coverPhoto'],
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'],
      phone: data['phone'],
      aboutMe: data['aboutMe'],
      location: data['location'],
      qualification: data['qualification'],
      facebook: data['facebook'],
      twitter: data['twitter'],
      linkdln: data['linkdln'],
      activated: data['activated'],
    );
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "avatar": avatar,
        "coverPhoto": coverPhoto,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "phone": phone,
        "aboutMe": aboutMe,
        "location": location,
        "qualification": qualification,
        "facebook": facebook,
        "twitter": twitter,
        "linkdln": linkdln,
        "activated": activated,
      };
}
