import 'package:flutter/material.dart';
import '../providers/HomeProvider.dart';
import '../screens/DrawerScreen.dart';
import '../screens/SearchScreen.dart';
import '../models/ScreenArguements.dart';
import '../screens/Downloader.dart';
import 'Home.dart';
import '../utils/my_colors.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.g.dart';
import '../providers/AudioPlayerModel.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  static const routeName = "/homescreen";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return HomePageItem();
  }
}

class HomePageItem extends StatefulWidget {
  HomePageItem({
    Key key,
  }) : super(key: key);

  @override
  _HomePageItemState createState() => _HomePageItemState();
}

class _HomePageItemState extends State<HomePageItem> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Provider.of<AudioPlayerModel>(context, listen: false)
                .currentMedia !=
            null) {
          return (await showDialog(
                context: context,
                builder: (context) => new CupertinoAlertDialog(
                  title: new Text(t.quitapp),
                  content: new Text(t.quitappaudiowarning),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text(t.cancel),
                    ),
                    new TextButton(
                      onPressed: () {
                        Provider.of<AudioPlayerModel>(context, listen: false)
                            .cleanUpResources();
                        Navigator.of(context).pop(true);
                      },
                      child: new Text(t.ok),
                    ),
                  ],
                ),
              )) ??
              false;
        } else {
          return (await showDialog(
                context: context,
                builder: (context) => new CupertinoAlertDialog(
                  title: new Text(t.quitapp),
                  content: new Text(t.quitappwarning),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text(t.cancel),
                    ),
                    new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: new Text(t.ok),
                    ),
                  ],
                ),
              )) ??
              false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          title: Text(t.appname),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    Icons.cloud_download,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Downloader.routeName,
                        arguments: ScreenArguements(
                          position: 0,
                          items: null,
                        ));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: (() {
                    Navigator.pushNamed(context, SearchScreen.routeName);
                  })),
            )
          ],
        ),
        body: ChangeNotifierProvider(
          create: (context) => HomeProvider(),
          child: MyHomePage(),
        ),
        drawer: Container(
          color: MyColors.grey_95,
          width: 300,
          child: Drawer(
            key: scaffoldKey,
            child: DrawerScreen(),
          ),
        ),
      ),
    );
  }
}
