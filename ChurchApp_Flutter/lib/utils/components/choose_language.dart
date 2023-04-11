import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/translate_provider.dart';
import '../../screens/language_page.dart';

class ChooseLanguage extends StatefulWidget {
  ChooseLanguage({Key key}) : super(key: key);

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  TranslateProvider _translateProvider;

  // Choose a new second language
  void _chooseSecondLanguage(String title, bool isAutomaticEnabled) async {
    final language = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguagePage(
          title: title,
          isAutomaticEnabled: isAutomaticEnabled,
        ),
      ),
    );

    if (language != null) {
      if (language != null) {
        _translateProvider.changeLanguages(language);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _translateProvider = Provider.of<TranslateProvider>(context, listen: true);

    return Container(
      height: 55.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.translate,
            ),
          ),
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () {
                  this._chooseSecondLanguage("Translate to", false);
                },
                child: Center(
                  child: Text(
                    "Translate to " + _translateProvider.secondLanguage.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _translateProvider.isTranslating
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(),
                )
              : InkWell(
                  onTap: () {
                    this._chooseSecondLanguage("Translate to", false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.mode_edit,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
