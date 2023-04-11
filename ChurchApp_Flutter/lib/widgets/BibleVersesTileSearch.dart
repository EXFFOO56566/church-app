import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/BibleModel.dart';
import '../screens/BibleVerseCompare.dart';
import '../models/ScreenArguements.dart';
import '../screens/BibleTranslator.dart';
import '../models/Bible.dart';
import '../utils/TextStyles.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';

class BibleVersesTileSearch extends StatefulWidget {
  final Bible object;
  final String query;

  const BibleVersesTileSearch({
    Key key,
    @required this.object,
    @required this.query,
  })  : assert(object != null),
        super(key: key);

  @override
  _BibleVersesTileState createState() => _BibleVersesTileState();
}

class _BibleVersesTileState extends State<BibleVersesTileSearch> {
  @override
  Widget build(BuildContext context) {
    BibleModel bibleModel = Provider.of<BibleModel>(context);
    int fontSize = bibleModel.selectedFontSize;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: DynamicTextHighlighting(
          text: widget.object.book +
              " " +
              widget.object.chapter.toString() +
              " vs" +
              widget.object.verse.toString() +
              ": \n" +
              widget.object.content,
          highlights: [widget.query],
          color: Colors.yellow,
          style: TextStyle(
            fontSize: fontSize.toDouble(),
          ),
          caseSensitive: false,
        ),
        /*RichText(
          text: TextSpan(
              style: TextStyles.subhead(context).copyWith(
                  //color: MyColors.grey_80,
                  fontWeight: FontWeight.w500),
              children: <TextSpan>[
                TextSpan(
                  text: widget.object.book +
                      " " +
                      widget.object.chapter +
                      " vs" +
                      widget.object.verse +
                      ": ",
                  style: TextStyle(fontSize: fontSize.toDouble()),
                ),
                TextSpan(
                  text: widget.object.content,
                  style: TextStyle(fontSize: fontSize.toDouble()),
                )
              ]),
        ),*/
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            children: <Widget>[
              Spacer(),
              Visibility(
                visible: bibleModel.downloadedBibleList.length > 1,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, BibleVerseCompare.routeName,
                        arguments: ScreenArguements(
                          position: 0,
                          items: widget.object,
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
                        items: widget.object,
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
            ],
          ),
        ),
      ),
    );
  }
}
