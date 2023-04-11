import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../screens/BibleVerseCompare.dart';
import '../models/ScreenArguements.dart';
import '../providers/BibleModel.dart';
import '../screens/BibleTranslator.dart';
import '../models/Bible.dart';
import '../utils/TextStyles.dart';

class BibleVersesTile extends StatefulWidget {
  final Bible object;
  final bool showCompare;

  const BibleVersesTile({
    Key key,
    @required this.object,
    @required this.showCompare,
  })  : assert(object != null),
        super(key: key);

  @override
  _BibleVersesTileState createState() => _BibleVersesTileState();
}

class _BibleVersesTileState extends State<BibleVersesTile> {
  @override
  Widget build(BuildContext context) {
    BibleModel bibleModel = Provider.of<BibleModel>(context);
    int fontSize = bibleModel.selectedFontSize;
    return InkWell(
      onTap: () {
        bibleModel.onVerseTapped(widget.object);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          title: Consumer<BibleModel>(
            builder: (context, bibleModel, child) {
              if (bibleModel.isBibleHighlighted(widget.object)) {
                return RichText(
                  text: TextSpan(
                    style: TextStyles.subhead(context).copyWith(
                        //color: MyColors.grey_80,
                        fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.object.verse.toString() + ". ",
                        style: TextStyle(fontSize: fontSize.toDouble()),
                      ),
                      TextSpan(
                        text: widget.object.content,
                        style: TextStyle(
                            fontSize: fontSize.toDouble(),
                            backgroundColor: Colors.grey[400]),
                      ),
                    ],
                  ),
                );
              } else {
                //print(bibleModel.coloredHighlightedBibleVerses[0].content);
                Bible bible =
                    bibleModel.getBibleColoredHighlightedVerse(widget.object);
                //print(bible);
                if (bible != null) {
                  return RichText(
                    text: TextSpan(
                      style: TextStyles.subhead(context).copyWith(
                          //color: MyColors.grey_80,
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: bible.verse.toString() + ". ",
                          style: TextStyle(fontSize: fontSize.toDouble()),
                        ),
                        TextSpan(
                          text: bible.content,
                          style: TextStyle(
                              fontSize: fontSize.toDouble(),
                              backgroundColor: bible.color == 0
                                  ? Colors.yellow
                                  : Color(bible.color)),
                        ),
                      ],
                    ),
                  );
                } else
                  return RichText(
                    text: TextSpan(
                      style: TextStyles.subhead(context).copyWith(
                          //color: MyColors.grey_80,
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.object.verse.toString() + ". ",
                          style: TextStyle(fontSize: fontSize.toDouble()),
                        ),
                        TextSpan(
                          text: widget.object.content,
                          style: TextStyle(fontSize: fontSize.toDouble()),
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: <Widget>[
                Spacer(),
                Visibility(
                  visible: widget.showCompare,
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
                        style:
                            TextStyles.caption(context).copyWith(fontSize: 15),
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
      ),
    );
  }
}
