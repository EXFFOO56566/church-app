import '../utils/my_colors.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import '../utils/Utility.dart';
import '../utils/ApiUrl.dart';
import '../utils/Alerts.dart';
import '../models/Userdata.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../models/Files.dart';
import '../utils/img.dart';

class MakePostScreen extends StatefulWidget {
  static const routeName = "/makepostscreen";
  MakePostScreen();

  @override
  MakePostScreenState createState() => new MakePostScreenState();
}

class MakePostScreenState extends State<MakePostScreen> {
  Userdata userdata;
  TextEditingController contentController = TextEditingController();
  List<Files> _selectedFiles = [];

  pickVideos() async {
    if (_selectedFiles.length >= 10) {
      Toast.show(t.maximumallowedsizehint, context);
      return;
    }
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      // allowCompression: true,
      allowMultiple: false,
      withData: false,
      allowedExtensions: ['mp4'],
    );
    if (mounted) {
      if (result != null) {
        PlatformFile file = result.files.first;

        print(file.name);
        //print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
        if (file.size > (1024 * 10)) {
          Toast.show(t.maximumuploadsizehint, context);
          return;
        }

        final filePath = await FlutterAbsolutePath.getAbsolutePath(file.path);
        print("video absolute path " + filePath);
        _selectedFiles.add(new Files(
            link: filePath,
            type: "video",
            filetype: file.extension,
            length: file.size,
            thumbnail: "null"));
        //genThumbnailFile(_selectedFiles.length - 1);
      }
      setState(() {});
    }
  }

  pickImages() async {
    if (_selectedFiles.length >= 10) {
      Toast.show(t.maximumallowedsizehint, context);
      return;
    }
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowMultiple: false,
      withData: false,
      allowedExtensions: ['png', 'PNG', 'JPEG', 'JPG', 'jpg', 'jpeg', 'gif'],
    );
    if (mounted) {
      if (result != null) {
        PlatformFile file = result.files.first;

        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
        if (file.size > (1024 * 10)) {
          Toast.show(t.maximumuploadsizehint, context);
          return;
        }

        _selectedFiles.add(new Files(
          link: file.path,
          type: "image",
          filetype: file.extension,
          length: file.size,
        ));
      }
      setState(() {});
    }
  }

  validateandsubmit() async {
    String _content = contentController.text;
    if (_content == "" && _selectedFiles.length == 0) {
      return;
    }
    submitPosttoServer(_content);
  }

  submitPosttoServer(
    String content,
  ) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    FormData formData = FormData.fromMap({
      "email": userdata.email,
      "visibility": "public",
      "content": Utility.getBase64EncodedString(content),
    });
    /*formData.files.addAll([
      MapEntry("avatar", MultipartFile.fromFileSync(avatar)),
      MapEntry("cover_photo", MultipartFile.fromFileSync(coverPhoto)),
    ]);
    
    formData.files.add(
        //MapEntry("avatar", MultipartFile.fromFileSync(avatar)),
        );*/
    _selectedFiles.forEach((element) {
      //"files_"+
      print("selected file item = " + element.toString());
      formData.files.add(MapEntry(
          "files_" + _selectedFiles.indexOf(element).toString(),
          MultipartFile.fromFileSync(element.link)));
    });
    print("selected files = " + _selectedFiles.toString());
    print("formadata file files = " + formData.files.toString());

    Dio dio = new Dio();

    try {
      var response = await dio.post(ApiUrl.makePost, data: formData,
          onSendProgress: (int send, int total) {
        print((send / total) * 100);
      });
      Navigator.of(context).pop();
      print(response.data);

      Map<String, dynamic> res = json.decode(response.data);
      if (res["status"] == "error") {
        Alerts.show(context, t.error, t.makeposterror);
        return;
      }
      Navigator.pop(context, true);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.makepost), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.done_all),
          onPressed: () {
            validateandsubmit();
          },
        ),
      ]),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 10.0),
                height: 120.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: _selectedFiles.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return InkWell(
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text(
                                    t.selectfile,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: Container(
                                    height: 120.0,
                                    width: 400.0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 2,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          title: Text(
                                              index == 0 ? t.images : t.videos),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            if (index == 0) {
                                              pickImages();
                                            } else {
                                              pickVideos();
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: MyColors.primary,
                            child: Center(
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    Files _files = _selectedFiles[index - 1];
                    if (_files.type == "image") {
                      return Stack(
                        children: [
                          Container(
                            height: 120,
                            width: 100,
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.file(
                                File.fromUri(Uri.parse(_files.link)),
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -10,
                            top: -10,
                            child: IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedFiles.removeAt(index - 1);
                                  });
                                }),
                          ),
                        ],
                      );
                    }

                    return Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 100,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 80,
                              width: 80,
                              child: Image.asset(
                                Img.get('video_thumbnail.jpg'),
                                height: 80,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -10,
                          top: -10,
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedFiles.removeAt(index - 1);
                                });
                              }),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 15, 0),
                    child: Text(_selectedFiles.length.toString() + "/10"),
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
              Divider(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    maxLength: 500,
                    maxLines: null,
                    controller: contentController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: t.shareYourThoughtsNow,
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
