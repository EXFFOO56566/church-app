import 'package:flutter/material.dart';
import '../providers/BibleModel.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../screens/BibleViewScreen.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../i18n/strings.g.dart';
import '../screens/BibleSearchScreen.dart';
import '../screens/BibleVersionsScreen.dart';

class BibleScreen extends StatefulWidget {
  static const routeName = "/biblescreen";

  @override
  _BibleScreenState createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  @override
  Widget build(BuildContext context) {
    BibleModel bibleModel = Provider.of<BibleModel>(context);
    int bibleversionsize = bibleModel.downloadedBibleList.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.biblebooks),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(BibleSearchScreen.routeName);
              },
              icon: Icon(Icons.search),
              iconSize: 25,
            ),
          )
        ],
      ),
      body: bibleversionsize == 0 ? EmptyLayout() : BibleViewScreen(),
    );
  }
}

class EmptyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(BibleVersionsScreen.routeName);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Lottie.asset("assets/lottie/bible.json",
                      height: 200, width: 200),
                ),
                Container(height: 0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(t.nobibleversionshint,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium(context).copyWith()),
                ),
                Container(height: 5),
                Container(
                  width: 180,
                  height: 40,
                  child: TextButton(
                    child: Text(t.downloadbible,
                        style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(BibleVersionsScreen.routeName);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
