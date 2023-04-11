import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/Bible.dart';
import '../database/SQLiteDbProvider.dart';
import '../providers/BibleModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../utils/ApiUrl.dart';
import '../models/Versions.dart';
import '../utils/TextStyles.dart';
import '../utils/img.dart';
import 'NoitemScreen.dart';
import '../i18n/strings.g.dart';

class BibleVersionsScreen extends StatelessWidget {
  static const routeName = "/bibleversions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.downloadbible),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: BibleVersionsScreenPageBody(),
      ),
    );
  }
}

class BibleVersionsScreenPageBody extends StatefulWidget {
  @override
  _BibleVersionsScreenBodyState createState() =>
      _BibleVersionsScreenBodyState();
}

class _BibleVersionsScreenBodyState extends State<BibleVersionsScreenPageBody> {
  bool isLoading = true;
  bool isError = false;
  List<Versions> items = [];

  Future<void> loadItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio
          .get(
        ApiUrl.GET_BIBLE,
      )
          .catchError((e) {
        print(e);
        setState(() {
          isLoading = false;
          isError = true;
        });
      });

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        print(res);
        List<Versions> _items = parseVersions(res);
        setState(() {
          isLoading = false;
          items = _items;
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(response);
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  static List<Versions> parseVersions(dynamic res) {
    // final res = jsonDecode(responseBody);
    final parsed = res["versions"].cast<Map<String, dynamic>>();
    return parsed.map<Versions>((json) => Versions.fromJson(json)).toList();
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: CupertinoActivityIndicator(
        radius: 20,
      ));
    } else if (isError) {
      return NoitemScreen(
          title: t.oops,
          message: t.dataloaderror,
          onClick: () {
            loadItems();
          });
    } else
      return ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(3),
        itemBuilder: (BuildContext context, int index) {
          return ItemTile(
            index: index,
            versions: items[index],
          );
        },
      );
  }
}

class ItemTile extends StatefulWidget {
  final Versions versions;
  final int index;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.versions,
  })  : assert(index != null),
        assert(versions != null),
        super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  int state =
      0; //pending download, 1 for downloading, 2 for downloaded, 3 for error, 4 for processing
  var downloadfilepath = "";
  String progress = '0';
  String msg = " 0 " + t.of + " 100";

  Future<void> downloadFile() async {
    if (!mounted) return;
    setState(() {
      state = 1;
    });
    Toast.show(t.bibledownloadinfo, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    downloadfilepath = await getFilePath();
    Dio dio = Dio();
    try {
      dio.download(
        widget.versions.source,
        downloadfilepath,
        onReceiveProgress: (rcv, total) {
          if (!mounted) return;
          print(t.received +
              ': ${rcv.toStringAsFixed(0)} ' +
              t.outoftotal +
              ': ${total.toStringAsFixed(0)}');

          setState(() {
            progress = ((rcv / total) * 100).toStringAsFixed(0);
            msg = ' $progress of 100';
          });

          if (progress == '100') {
            setState(() {
              // isDownloaded = true;
            });
          } else if (double.parse(progress) < 100) {}
        },
        deleteOnError: true,
      ).then((_) {
        if (!mounted) return;
        setState(() {
          if (progress == '100') {
            state = 4;
          }
        });
        print(downloadfilepath);
        savetodatabase();
      }).catchError((e) {
        print(e);
        if (!mounted) return;
        Toast.show(
            t.failedtodownload +
                widget.versions.name +
                ", " +
                t.pleaseclicktoretry,
            context);
        setState(() {
          state = 3;
        });
      });
    } catch (e) {
      print(e.runtimeType);
      if (!mounted) return;
      Toast.show(
          t.failedtodownload +
              widget.versions.name +
              ", " +
              t.pleaseclicktoretry,
          context);
      setState(() {
        state = 3;
      });
    }
  }

  String getText() {
    if (state == 1) {
      return t.downloaded + " " + msg;
    }
    if (state == 2) {
      return t.downloaded;
    }
    if (state == 3) {
      return t.retry;
    }
    if (state == 4) {
      return t.processingpleasewait;
    }
    return t.download;
  }

  Future<String> getFilePath() async {
    String path = '';
    var uniqueFileName = widget.versions.code;
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName.json';
    return path;
  }

  savetodatabase() {
    String jobsString = "";
    final file = new File(downloadfilepath);
    Stream<List<int>> inputStream = file.openRead();
    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) async {
      jobsString += line;
    }, onDone: () async {
      debugPrint('File is now closed.');
      List<dynamic> biblejson = await jsonDecode(jobsString);
      List<Bible> bibleList = parseBible(biblejson);
      print("downloaded bible size = " + bibleList.length.toString());
      await SQLiteDbProvider.db.insertBatchBible(bibleList);
      await SQLiteDbProvider.db.insertBibleVersion(widget.versions);
      Provider.of<BibleModel>(context, listen: false).getDownloadedBibleList();
      setState(() {
        state = 2;
      });
    }, onError: (e) {
      print(e.toString());
    });
  }

  List<Bible> parseBible(dynamic res) {
    final parsed = res.cast<Map<String, dynamic>>();
    return parsed
        .map<Bible>((json) => Bible.fromJson(json, widget.versions.code))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      if (Provider.of<BibleModel>(context, listen: false)
          .isBibleVersionDownloaded(widget.versions)) {
        setState(() {
          state = 2;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Card(
                    margin: EdgeInsets.all(0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 40,
                      width: 60,
                      child: Image.asset(
                        Img.get('bible_data.PNG'),
                        fit: BoxFit.fill,
                        //color: Colors.black26,
                      ),
                    )),
                Container(width: 10),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(widget.versions.name,
                            maxLines: 1,
                            style: TextStyles.subhead(context).copyWith(
                                //color: MyColors.grey_80,
                                fontWeight: FontWeight.w500)),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(widget.versions.description,
                            maxLines: 3,
                            style: TextStyles.subhead(context).copyWith(
                                //color: MyColors.grey_80
                                )),
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          /*Consumer<BibleModel>(
                            builder: (context, bibleModel, child) {
                              if(bibleModel
                                  .isBibleVersionDownloaded(widget.versions);
                              
                            },
                          ),*/
                          InkWell(
                            child: Text(getText(),
                                maxLines: 1,
                                style: TextStyles.subhead(context).copyWith(
                                    //color: MyColors.grey_80,
                                    fontWeight: FontWeight.w500)),
                            onTap: () {
                              if (state == 0 || state == 3) {
                                downloadFile();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          Divider(
            height: 0.1,
            //color: Colors.grey.shade800,
          )
        ],
      ),
    );
  }
}
