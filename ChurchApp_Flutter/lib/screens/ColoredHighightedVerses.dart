import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ScreenArguements.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '../screens/BibleVerseCompare.dart';
import 'BibleTranslator.dart';
import '../providers/BibleModel.dart';
import '../models/Bible.dart';
import '../utils/TextStyles.dart';

class ColoredHighightedVerses extends StatefulWidget {
  static const routeName = "/highlightedcoloredverses";

  @override
  _ColoredHighightedVersesState createState() =>
      _ColoredHighightedVersesState();
}

class _ColoredHighightedVersesState extends State<ColoredHighightedVerses> {
  Future<List<Bible>> bibleLoader;
  bool showClear = false;
  String query = "";
  int selectedColor = 0;
  String filterByText = "";
  bool showFIlterColorHint = false;
  final TextEditingController inputController = new TextEditingController();

  @override
  void initState() {
    bibleLoader = Provider.of<BibleModel>(context, listen: false)
        .showColoredHighlightedVerses("", 0);
    super.initState();
  }

  callback() {
    setState(() {
      bibleLoader = Provider.of<BibleModel>(context, listen: false)
          .showColoredHighlightedVerses("", 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onChanged: (term) {
            if (term.length > 0) {
              setState(() {
                selectedColor = 0;
                showFIlterColorHint = false;
              });
              bibleLoader = Provider.of<BibleModel>(context, listen: false)
                  .showColoredHighlightedVerses(term, selectedColor);
              showClear = true;
            } else if (term.length == 0) {
              inputController.clear();
              showClear = false;
              setState(() {
                query = "";
              });
              bibleLoader = Provider.of<BibleModel>(context, listen: false)
                  .showColoredHighlightedVerses("", 0);
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Highlighted Bible Verses",
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
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
                    bibleLoader =
                        Provider.of<BibleModel>(context, listen: false)
                            .showColoredHighlightedVerses("", 0);
                  },
                )
              : Container(),
          InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.color_lens, color: Colors.yellow, size: 25.0),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(6.0),
                      title: Text("Filter By Color"),
                      content: Container(
                        height: 230,
                        child: MaterialColorPicker(
                          selectedColor: Color(selectedColor),
                          allowShades: false,
                          onMainColorChange: (color) {
                            print(Color(color.value));
                            selectedColor = color.value;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('CANCEL'),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        TextButton(
                          child: Text('FILTER'),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();

                            bibleLoader =
                                Provider.of<BibleModel>(context, listen: false)
                                    .showColoredHighlightedVerses(
                                        "", selectedColor);
                            setState(() {
                              filterByText = "Filtered by  ";
                              showFIlterColorHint = true;
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: showFIlterColorHint,
            child: Container(
              height: 50,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                margin: EdgeInsets.all(0),
                elevation: 10,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 15,
                      ),
                      Expanded(
                        child: Row(children: <Widget>[
                          Container(
                            width: 15,
                          ),
                          Text(
                            filterByText,
                            maxLines: 1,
                            style: TextStyles.subhead(context)
                                .copyWith(fontSize: 17),
                          ),
                          ClipOval(
                            child: Container(
                              color: Color(selectedColor),
                              width: 30.0,
                              height: 30.0,
                            ),
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Container(
                            color: Theme.of(context).accentColor.withAlpha(30),
                            width: 30.0,
                            height: 30.0,
                            child: IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              onPressed: () {
                                setState(() {
                                  showFIlterColorHint = false;
                                  selectedColor = 0;
                                });
                                bibleLoader = Provider.of<BibleModel>(context,
                                        listen: false)
                                    .showColoredHighlightedVerses("", 0);
                              },
                              icon: Icon(
                                Icons.cancel,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<Bible>>(
              future: bibleLoader,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                } else {
                  List<Bible> currentBibleList = snapshot.data;
                  if (currentBibleList.length == 0) {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "No verses found",
                          style: TextStyles.subhead(context)
                              .copyWith(fontSize: 17),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: currentBibleList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return ColoredBibleVersesTile(
                          object: currentBibleList[index],
                          showCompare: true,
                          callback: callback,
                        );
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class ColoredBibleVersesTile extends StatelessWidget {
  final Bible object;
  final bool showCompare;
  final Function callback;

  const ColoredBibleVersesTile({
    Key key,
    @required this.object,
    @required this.showCompare,
    @required this.callback,
  })  : assert(object != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    BibleModel bibleModel = Provider.of<BibleModel>(context);
    int fontSize = bibleModel.selectedFontSize;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: RichText(
          text: TextSpan(
              style: TextStyles.subhead(context).copyWith(
                  //color: MyColors.grey_80,
                  fontWeight: FontWeight.w500),
              children: <TextSpan>[
                TextSpan(
                  text: object.book +
                      " Chapter " +
                      object.chapter.toString() +
                      " Vs" +
                      object.verse.toString() +
                      " (" +
                      object.version +
                      ")" +
                      ": \n",
                  style: TextStyle(fontSize: fontSize.toDouble()),
                ),
                TextSpan(
                  text: object.content,
                  style: TextStyle(
                      fontSize: fontSize.toDouble(),
                      backgroundColor: object.color == 0
                          ? Colors.yellow
                          : Color(object.color)),
                ),
              ]),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            children: <Widget>[
              Spacer(),
              Visibility(
                visible: true,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, BibleVerseCompare.routeName,
                        arguments: ScreenArguements(
                          position: 0,
                          items: object,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "compare",
                      style: TextStyles.caption(context).copyWith(fontSize: 15),
                    ),
                  ),
                ),
              ),
              Container(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, BibleTranslator.routeName,
                      arguments: ScreenArguements(
                        position: 0,
                        items: object,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "translate",
                    style: TextStyles.caption(context).copyWith(fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: 20,
              ),
              InkWell(
                child: Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 20.0),
                onTap: () {
                  bibleModel.removeColoredVerse(object);
                  callback();
                },
              ),
              Container(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
