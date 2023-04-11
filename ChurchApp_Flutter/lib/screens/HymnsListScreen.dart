import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import '../models/ScreenArguements.dart';
import 'dart:async';
import 'dart:math';
import '../screens/BookmarkedHymnsListScreen.dart';
import 'package:clipboard/clipboard.dart';
import 'package:provider/provider.dart';
import '../providers/HymnsBookmarksModel.dart';
import 'package:flutter_share/flutter_share.dart';
import '../screens/HymnsViewerScreen.dart';
import '../models/Hymns.dart';
import 'NoitemScreen.dart';
import '../i18n/strings.g.dart';
import '../utils/TextStyles.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dio/dio.dart';
import '../utils/ApiUrl.dart';

class HymnsListScreen extends StatefulWidget {
  static const routeName = "/hymnslist";

  @override
  _HymnsListScreenState createState() => _HymnsListScreenState();
}

class _HymnsListScreenState extends State<HymnsListScreen> {
  BuildContext context;
  bool showClear = false;
  String query = "";
  final TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onSubmitted: (_query) {
            setState(() {
              query = _query;
              showClear = (_query.length > 0);
            });
          },
          onChanged: (term) {
            /* setState(() {
              showClear = (term.length > 2);
            });*/
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: t.hymns,
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    setState(() {
                      query = "";
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(BookmarkedHymnsListScreen.routeName);
                  }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: HymnScreenBody(
          query: query,
          key: UniqueKey(),
        ),
      ),
    );
  }
}

class HymnScreenBody extends StatefulWidget {
  final String query;

  const HymnScreenBody({
    Key key,
    @required this.query,
  }) : super(key: key);
  @override
  HymnScreenBodyBodyRouteState createState() =>
      new HymnScreenBodyBodyRouteState();
}

class HymnScreenBodyBodyRouteState extends State<HymnScreenBody> {
  List<Hymns> items = [];
  bool isLoading = false;
  bool isError = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  void _onRefresh() async {
    loadItems();
  }

  void _onLoading() async {
    loadMoreItems();
  }

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    setState(() {});
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Hymns> item) {
    items.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    setState(() {});
  }

  void setMoreItems(List<Hymns> item) {
    refreshController.loadComplete();
    isError = false;
    items.addAll(item);
    setState(() {});
  }

  Future<void> fetchItems() async {
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.HYMNS,
        data: jsonEncode({
          "data": {"query": widget.query, "page": page.toString()}
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        print(res);
        List<Hymns> mediaList = parseSliderMedia(res);
        if (page == 0) {
          setItems(mediaList);
        } else {
          setMoreItems(mediaList);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  static List<Hymns> parseSliderMedia(dynamic res) {
    final parsed = res["hymns"].cast<Map<String, dynamic>>();
    return parsed.map<Hymns>((json) => Hymns.fromJson(json)).toList();
  }

  setFetchError() {
    if (page == 0) {
      setState(() {
        isError = true;
        refreshController.refreshFailed();
      });
    } else {
      setState(() {
        refreshController.loadFailed();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (isError == true && items.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  object: items[index],
                );
              },
            ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final Hymns object;

  const ItemTile({
    Key key,
    @required this.object,
  })  : assert(object != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("thumbnail = " + object.thumbnail);
        Navigator.of(context).pushNamed(HymnsViewerScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items: object,
              itemsList: [],
            ));
      },
      child: Container(
        height: 70,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    width: 30,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      child: Text(
                        object.title.substring(0, 1),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(width: 15),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(object.title,
                              maxLines: 1,
                              style: TextStyles.subhead(context)
                                  .copyWith(fontSize: 18)),
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            Row(
                              children: <Widget>[
                                Consumer<HymnsBookmarksModel>(
                                  builder: (context, bookmarksModel, child) {
                                    bool isBookmarked =
                                        bookmarksModel.isHymnBookmarked(object);
                                    return InkWell(
                                      child: Icon(Icons.bookmark,
                                          color: isBookmarked
                                              ? Colors.redAccent
                                              : Colors.grey,
                                          size: 20.0),
                                      onTap: () {
                                        if (isBookmarked)
                                          bookmarksModel.unBookmarkHymn(object);
                                        else
                                          bookmarksModel.bookmarkHymn(object);
                                      },
                                    );
                                  },
                                ),
                                Container(width: 10),
                                InkWell(
                                  child: Icon(Icons.share,
                                      color: Colors.lightBlue, size: 20.0),
                                  onTap: () async {
                                    await FlutterShare.share(
                                        title: object.title,
                                        text: object.content);
                                  },
                                ),
                                Container(width: 10),
                                InkWell(
                                  child: Icon(Icons.content_copy,
                                      color: Colors.orange, size: 20.0),
                                  onTap: () {
                                    FlutterClipboard.copy(object.content).then(
                                        (value) => Toast.show(
                                            t.copiedtoclipboard, context));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 0.1,
              //color: Colors.grey.shade800,
            )
          ],
        ),
      ),
    );
  }
}
