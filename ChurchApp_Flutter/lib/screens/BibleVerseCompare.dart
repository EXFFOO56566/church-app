import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ScreenArguements.dart';
import '../screens/BibleTranslator.dart';
import '../providers/BibleModel.dart';
import '../models/Bible.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../i18n/strings.g.dart';

class BibleVerseCompare extends StatelessWidget {
  static const routeName = "/biblecomparescreen";
  final Bible bible;
  BibleVerseCompare({this.bible});

  @override
  Widget build(BuildContext context) {
    BibleModel bibleModel = Provider.of<BibleModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare Versions"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        style: TextStyles.subhead(context)
                            .copyWith(fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                            text: bible.book +
                                " Chapter " +
                                bible.chapter.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ]),
                  ),
                  Container(
                    width: 130,
                    height: 2,
                    color: MyColors.primary,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<Bible>>(
              future: bibleModel.showCurrentBibleVerseData(bible.verse),
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
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: currentBibleList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return BibleVersesTile(
                          object: currentBibleList[index],
                          showCompare: false,
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

class BibleVersesTile extends StatelessWidget {
  final Bible object;
  final bool showCompare;

  const BibleVersesTile({
    Key key,
    @required this.object,
    @required this.showCompare,
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
                  text: object.version + ": \n",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: object.verse.toString() + ". ",
                  style: TextStyle(fontSize: fontSize.toDouble()),
                ),
                TextSpan(
                  text: object.content,
                  style: TextStyle(fontSize: fontSize.toDouble()),
                ),
              ]),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            children: <Widget>[
              Spacer(),
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
                    t.translate,
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
