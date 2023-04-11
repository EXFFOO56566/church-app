import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import '../models/ScreenArguements.dart';
import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:provider/provider.dart';
import '../providers/HymnsBookmarksModel.dart';
import 'package:flutter_share/flutter_share.dart';
import 'HymnsViewerScreen.dart';
import '../models/Hymns.dart';
import '../i18n/strings.g.dart';
import '../utils/TextStyles.dart';
import '../screens/EmptyListScreen.dart';

class BookmarkedHymnsListScreen extends StatefulWidget {
  static const routeName = "/bookmarkedhymnslist";

  @override
  _HymnsListScreenState createState() => _HymnsListScreenState();
}

class _HymnsListScreenState extends State<BookmarkedHymnsListScreen> {
  HymnsBookmarksModel hymnsBookmarksModel;
  BuildContext context;
  bool showClear = false;
  String query = "";
  final TextEditingController inputController = new TextEditingController();
  List<Hymns> items = [];

  @override
  Widget build(BuildContext context) {
    hymnsBookmarksModel = Provider.of<HymnsBookmarksModel>(context);
    items = hymnsBookmarksModel.bookmarksList;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onChanged: (term) {
            if (term.length > 0) {
              hymnsBookmarksModel.searchHymns(term);
              showClear = true;
            } else if (term.length == 0) {
              showClear = false;
              hymnsBookmarksModel.getBookmarks();
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: t.notes,
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
                    hymnsBookmarksModel.getBookmarks();
                  },
                )
              : Container(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: (items.length == 0)
            ? EmptyListScreen(
                message: t.noitemstodisplay,
              )
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
