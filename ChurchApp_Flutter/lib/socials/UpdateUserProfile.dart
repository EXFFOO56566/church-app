import '../socials/UserProfileScreen.dart';
import '../utils/ApiUrl.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';
import '../models/Userdata.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import '../socials/FollowPeople.dart';
import '../models/ScreenArguements.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../i18n/strings.g.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:media_picker/media_picker.dart';
import '../utils/img.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UpdateUserProfile extends StatefulWidget {
  static const routeName = "/updateprofile";
  UpdateUserProfile({this.check});
  final bool check;

  @override
  UpdateUserProfileState createState() => new UpdateUserProfileState();
}

class UpdateUserProfileState extends State<UpdateUserProfile> {
  Userdata userdata;
  String gender = "Male";
  TextStyle textStyle = TextStyle(height: 1.4, fontSize: 16);
  TextStyle labelStyle = TextStyle();
  UnderlineInputBorder lineStyle1 = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[800], width: 1));
  UnderlineInputBorder lineStyle2 = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[800], width: 2));
  String avatar = "";
  String coverPhoto = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController linkdlnController = TextEditingController();
  List<dynamic> _mediaPaths;

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    } else {
      print("picked null" + picked.toString());
    }
  }

  pickImages(String type, {quantity = 1}) async {
    try {
      _mediaPaths = await MediaPicker.pickImages(
          withVideo: false,
          withCamera: false,
          quantity: quantity,
          quality: 50,
          maxHeight: 300,
          maxWidth: 300);
    } on PlatformException {
      Alerts.show(context, t.error, t.couldnotprocess);
    }
    if (!mounted) return;
    convertPath(_mediaPaths.first.toString(), type);
  }

  convertPath(String uri, String type) async {
    print("convert file");
    final filePath = await FlutterAbsolutePath.getAbsolutePath(uri);
    if (type == "avatar") {
      print("avatar changed");
      setState(() {
        avatar = filePath;
      });
    } else {
      print("coverphoto changed");
      setState(() {
        coverPhoto = filePath;
      });
    }
  }

  validateandsubmit() async {
    String _name = nameController.text;
    String _phone = phoneController.text;
    String _dob = dobController.text;
    String _location = locationController.text;
    String _qualification = qualificationController.text;
    String _about = aboutController.text;
    String _facebook = facebookController.text;
    String _twitter = twitterController.text;
    String _lindln = linkdlnController.text;

    if (userdata.avatar == "" && avatar == "") {
      Alerts.show(context, t.error, t.pleaseselectprofilephoto);
    } else if (userdata.coverPhoto == "" && coverPhoto == "") {
      Alerts.show(context, t.error, t.pleaseselectprofilecover);
    } else if (_name == "" ||
        gender == "" ||
        _phone == "" ||
        _location == "" ||
        _dob == "") {
      Alerts.show(context, t.error, t.updateprofileerrorhint);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      uploadFileFromDio(_name, _dob, _phone, _location, _qualification, _about,
          _facebook, _twitter, _lindln, prefs.getString("firebase_token"));
    }
  }

  uploadFileFromDio(
      String name,
      String dob,
      String phone,
      String location,
      String qualification,
      String aboutme,
      String facebook,
      String twitter,
      String linkedln,
      String token) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    FormData formData = FormData.fromMap({
      "email": userdata.email,
      "fullname": name,
      "date_of_birth": dob,
      "phone": phone,
      "gender": gender,
      "location": location,
      "qualification": qualification,
      "about_me": Utility.getBase64EncodedString(aboutme),
      "facebook": facebook,
      "twitter": twitter,
      "linkedln": linkedln,
      "notify_token": token
    });
    /*formData.files.addAll([
      MapEntry("avatar", MultipartFile.fromFileSync(avatar)),
      MapEntry("cover_photo", MultipartFile.fromFileSync(coverPhoto)),
    ]);*/
    if (avatar != "") {
      formData.files.add(
        MapEntry("avatar", MultipartFile.fromFileSync(avatar)),
      );
    }
    if (coverPhoto != "") {
      formData.files.add(
        MapEntry("cover_photo", MultipartFile.fromFileSync(coverPhoto)),
      );
    }
    print(formData.files);

    Dio dio = new Dio();

    try {
      var response = await dio.post(ApiUrl.BASEURL + "updateProfile",
          data: formData, onSendProgress: (int send, int total) {
        print((send / total) * 100);
      });
      Navigator.of(context).pop();
      print(response.data);
      Map<String, dynamic> res = json.decode(response.data);
      if (res["status"] == "error") {
        Alerts.show(context, t.error, res["msg"]);
        return;
      }
      Userdata userdata = Userdata.fromJsonActivated(res["user"]);
      print(userdata.avatar);
      Provider.of<AppStateManager>(context, listen: false)
          .setUserData(userdata);

      if (widget.check) {
        Navigator.pushReplacementNamed(context, FollowPeople.routeName,
            arguments: ScreenArguements(
              check: true,
            ));
      } else {
        Navigator.pushReplacementNamed(context, UserProfileScreen.routeName,
            arguments: ScreenArguements(
              items: userdata,
            ));
      }
    } on DioError catch (e) {
      Navigator.of(context).pop();
      Alerts.show(context, t.error, e.message);
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
      } else {
        //print(e.request.headers);
        print(e.message);
      }
    }
  }

  @override
  void initState() {
    userdata = Provider.of<AppStateManager>(context, listen: false).userdata;
    if (userdata.gender != "") {
      gender = userdata.gender;
    }
    dobController.text = userdata.dateOfBirth;
    nameController.text = userdata.name;
    phoneController.text = userdata.phone;
    locationController.text = userdata.location;
    qualificationController.text = userdata.qualification;
    aboutController.text = userdata.aboutMe == ""
        ? ""
        : Utility.getBase64DecodedString(userdata.aboutMe);
    facebookController.text = userdata.facebook;
    twitterController.text = userdata.twitter;
    linkdlnController.text = userdata.linkdln;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Userdata userdata = Provider.of<AppStateManager>(context).userdata;
    return Scaffold(
      appBar: AppBar(
          title: Text(t.updateprofile),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, UserProfileScreen.routeName,
                  arguments: ScreenArguements(
                    items: userdata,
                  ));
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done_all),
              onPressed: () {
                validateandsubmit();
              },
            ),
          ]),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    height: 280,
                  ),
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.blueGrey,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: coverPhoto != ""
                              ? Image.file(
                                  File.fromUri(Uri.parse(coverPhoto)),
                                  height: 220,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : (userdata.coverPhoto != ""
                                  ? CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: userdata.coverPhoto,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black12,
                                                  BlendMode.darken)),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                          child: CupertinoActivityIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: Image.asset(
                                          Img.get('cover_photos.jpg'),
                                        ),
                                      ),
                                    )
                                  : Icon(Icons.photo,
                                      size: 200, color: Colors.white)),
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, 40.0, 0.0),
                          margin: EdgeInsets.all(15),
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: "fab4",
                            backgroundColor: Colors.blueGrey[800],
                            elevation: 3,
                            child: IconButton(
                                onPressed: () {
                                  pickImages("coverphoto");
                                },
                                icon: Icon(Icons.photo_camera,
                                    color: Colors.white)),
                            onPressed: () {
                              pickImages("coverphoto");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.blueGrey[300],
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: avatar != ""
                                  ? Image.file(
                                      File.fromUri(Uri.parse(avatar)),
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    )
                                  : (userdata.avatar != ""
                                      ? CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: userdata.avatar,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black12,
                                                      BlendMode.darken)),
                                            ),
                                          ),
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CupertinoActivityIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Image.asset(
                                              Img.get('cover_photos.jpg'),
                                            ),
                                          ),
                                        )
                                      : Icon(Icons.person,
                                          size: 80, color: Colors.white)),
                            ),
                            Positioned(
                              child: Container(
                                transform:
                                    Matrix4.translationValues(0.0, 0.0, 0.0),
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                  heroTag: "fab3",
                                  mini: true,
                                  backgroundColor: Colors.blueGrey[800],
                                  elevation: 3,
                                  child: Icon(Icons.photo_camera,
                                      size: 18, color: Colors.white),
                                  onPressed: () {
                                    pickImages("avatar");
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      style: textStyle,
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.person),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.fullname,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                    Container(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        t.gender,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(height: 4),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Container(width: 0),
                          Container(
                            width: 150,
                            height: 50,
                            child: RadioListTile<String>(
                              title: Text(t.male),
                              value: "Male",
                              groupValue: gender,
                              onChanged: (String value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),
                          Container(width: 0),
                          Container(
                            width: 150,
                            height: 50,
                            child: RadioListTile<String>(
                              title: Text(t.female),
                              value: "Female",
                              groupValue: gender,
                              onChanged: (String value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                    Container(height: 10),
                    TextField(
                      style: textStyle,
                      controller: dobController,
                      enableInteractiveSelection: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _selectDate(context);
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.date_range),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.dob,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                    Container(height: 10),
                    TextField(
                      style: textStyle,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.phone),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.phonenumber,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                    Container(height: 10),
                    TextField(
                      style: textStyle,
                      controller: locationController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.location_city),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.location,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                    Container(height: 10),
                    TextField(
                      style: textStyle,
                      controller: qualificationController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.work),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.qualification,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                    Container(height: 10),
                    TextField(
                      style: textStyle,
                      controller: aboutController,
                      keyboardType: TextInputType.multiline,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.child_care),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.aboutme,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                    Container(height: 10),
                    TextField(
                      style: textStyle,
                      controller: facebookController,
                      keyboardType: TextInputType.url,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.phone),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.facebookprofilelink,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                    Container(height: 10),
                    TextField(
                      style: textStyle,
                      controller: twitterController,
                      keyboardType: TextInputType.url,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.phone),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.twitterprofilelink,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                    Container(height: 10),
                    TextField(
                      style: textStyle,
                      controller: linkdlnController,
                      keyboardType: TextInputType.url,
                      cursorColor: Colors.pink[800],
                      decoration: InputDecoration(
                        icon: Container(
                            child: Icon(Icons.phone),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                        labelText: t.linkdln,
                        labelStyle: labelStyle,
                        enabledBorder: lineStyle1,
                        focusedBorder: lineStyle2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
