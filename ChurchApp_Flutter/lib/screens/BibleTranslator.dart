import 'package:flutter/material.dart';
import '../models/Bible.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../utils/components/choose_language.dart';
import '../providers/translate_provider.dart';
import 'package:provider/provider.dart';

class BibleTranslator extends StatefulWidget {
  static const routeName = "/bibletranslator";
  final Bible bible;
  BibleTranslator({this.bible});

  @override
  _BibleTranslatorPageState createState() => _BibleTranslatorPageState();
}

class _BibleTranslatorPageState extends State<BibleTranslator> {
  TranslateProvider translateProvider;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<TranslateProvider>(context, listen: false)
          .transateVerse(widget.bible.content);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    translateProvider = Provider.of<TranslateProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(t.bibletranslator),
      ),
      body: Column(
        children: <Widget>[
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
                            text: widget.bible.book +
                                t.chapter +
                                widget.bible.chapter.toString() +
                                t.verse +
                                widget.bible.verse.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ]),
                  ),
                  Container(
                    width: 200,
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
            child: Card(
              margin: EdgeInsets.all(0.0),
              elevation: 0.0,
              child: Container(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 20),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyles.subhead(context).copyWith(
                            //color: MyColors.grey_80,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.bible.content,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ),
          ChooseLanguage(),
          Expanded(
            child: Card(
              margin: EdgeInsets.all(0.0),
              elevation: 2.0,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                        child: Text(
                          translateProvider.textTranslated,
                          style: TextStyle(fontSize: 20.0),
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
    );
  }
}
