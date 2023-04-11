import 'package:churchapp_flutter/providers/AppStateManager.dart';
import '../screens/BibleScreen.dart';
import '../providers/AudioPlayerModel.dart';
import '../audio_player/miniPlayer.dart';
import '../models/ScreenArguements.dart';
import '../models/Userdata.dart';
import '../screens/BranchesScreen.dart';
import '../livetvplayer/LivestreamsPlayer.dart';
import '../screens/EventsListScreen.dart';
import '../screens/InboxListScreen.dart';
import '../screens/HymnsListScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:churchapp_flutter/utils/my_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/CategoriesScreen.dart';
import '../screens/DevotionalScreen.dart';
import '../screens/VideoScreen.dart';
import '../screens/AudioScreen.dart';
import '../notes/NotesListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/HomeProvider.dart';
import '../utils/img.dart';
import '../models/Media.dart';
import '../models/Radios.dart';
import '../i18n/strings.g.dart';
import '../utils/TextStyles.dart';
import '../screens/HomeSlider.dart';
import '../screens/NoitemScreen.dart';
import '../utils/ApiUrl.dart';
import 'package:shimmer/shimmer.dart';

enum HomeIndex { CATEGORIES, VIDEOS, AUDIOS, BIBLEBOOKS, LIVESTREAMS, RADIO }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.userdata}) : super(key: key);
  final Userdata userdata;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeProvider homeProvider;

  @override
  void initState() {
    Provider.of<HomeProvider>(context, listen: false).loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Appbar(),
            Expanded(
              child: HomePageBody(
                homeProvider: homeProvider,
                key: UniqueKey(),
              ),
            ),
            MiniPlayer(),
          ],
        ),
      ),
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    Key key,
    @required this.homeProvider,
  }) : super(key: key);

  final HomeProvider homeProvider;

  onRetryClick() {
    homeProvider.loadItems();
  }

  openBrowserTab(String url) async {
    await FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: MyColors.primary,
        secondaryToolbarColor: MyColors.primary,
        navigationBarColor: MyColors.primary,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: MyColors.primary,
        preferredControlTintColor: MyColors.primary,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppStateManager>(context);
    if (homeProvider.isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 12,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (homeProvider.isError) {
      return NoitemScreen(
          title: t.oops, message: t.dataloaderror, onClick: onRetryClick);
    } else
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: Text(
                  t.suggestedforyou,
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            HomeSlider(homeProvider.data['sliders']),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0.00,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab1",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.lightGreen[500],
                              child: Icon(
                                Icons.camera,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                openBrowserTab(homeProvider.data['website']);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(
                                t.website,
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab8",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.orange[300],
                              child: Icon(
                                Icons.location_city,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(BranchesScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(
                                t.branches,
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab3",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.purple[400],
                              child: Icon(
                                Icons.library_books,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(HymnsListScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(
                                t.hymns,
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab4",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.blue[400],
                              child: Icon(
                                Icons.event,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(EventsListScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(
                                t.events,
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab5",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.indigo[300],
                              child: Icon(
                                Icons.email,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(InboxListScreenState.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(
                                t.inbox,
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab6",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.green[500],
                              child: Icon(
                                Icons.library_books,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(DevotionalScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(
                                t.devotionals,
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab7",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.lightGreen[400],
                              child: Icon(
                                Icons.book,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(NotesListScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(
                                t.notes,
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab2",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.yellow[600],
                              child: Icon(
                                Icons.attach_money,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                openBrowserTab(ApiUrl.DONATE);
                                /*await showDialog(
                                  context: context,
                                  builder: (context) =>
                                      new CupertinoAlertDialog(
                                    title: new Text("OOOPS!!!"),
                                    content: new Text(
                                        "The Donation feature is currently disabled on the test app. Because Google requires organization’s IRS determination letter inorder to use donations on their app. To use this feature on your purchased app, you will have to send some church documents to google. For now you can test this feature by copying the URL below to your mobile web browser.\n https://mychurch.envisionapps.net/donate"),
                                    actions: <Widget>[
                                      new FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: new Text(t.cancel),
                                      ),
                                      new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: new Text(t.ok),
                                      ),
                                    ],
                                  ),
                                );*/
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(
                                t.donate,
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(height: 15),
                  ],
                ),
              ),
            ),
            Container(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ItemTile(
                    index: HomeIndex.CATEGORIES,
                    homeProvider: homeProvider,
                    title: t.categories,
                    thumbnail: "",
                    useAssetsImage: true,
                    assetsImage: "assets/images/messages.jpg",
                  ),
                ),
                Expanded(
                  child: ItemTile(
                    index: HomeIndex.VIDEOS,
                    homeProvider: homeProvider,
                    title: t.videos,
                    thumbnail: homeProvider.data['image2'],
                    useAssetsImage: homeProvider.data['image2'] == "",
                    assetsImage: "assets/images/messages.jpg",
                  ),
                ),
                Expanded(
                  child: ItemTile(
                    index: HomeIndex.AUDIOS,
                    homeProvider: homeProvider,
                    title: t.audios,
                    thumbnail: homeProvider.data['image2'],
                    useAssetsImage: homeProvider.data['image2'] == "",
                    assetsImage: "assets/images/sermons.jpg",
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ItemTile(
                    index: HomeIndex.BIBLEBOOKS,
                    homeProvider: homeProvider,
                    title: t.biblebooks,
                    thumbnail: homeProvider.data['image3'],
                    useAssetsImage: homeProvider.data['image3'] == "",
                    assetsImage: "assets/images/bible.jpg",
                  ),
                ),
                Expanded(
                  child: ItemTile(
                    index: HomeIndex.LIVESTREAMS,
                    homeProvider: homeProvider,
                    title: t.livestreams,
                    thumbnail: homeProvider.data['image4'],
                    useAssetsImage: homeProvider.data['image4'] == "",
                    assetsImage: "assets/images/livestream.jpg",
                  ),
                ),
                Expanded(
                  child: ItemTile(
                    index: HomeIndex.RADIO,
                    homeProvider: homeProvider,
                    title: t.radio,
                    thumbnail: homeProvider.data['image5'],
                    useAssetsImage: homeProvider.data['image5'] == "",
                    assetsImage: "assets/images/radio.jpg",
                  ),
                ),
              ],
            ),
            Container(height: 20),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: Text(
                  "Follow us on",
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)),
              //color: Colors.white,
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        openBrowserTab(homeProvider.data['facebook_page']);
                      },
                      child: Container(
                        child: Image.asset(Img.get('img_social_facebook.png')),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Container(width: 10),
                    InkWell(
                      onTap: () {
                        openBrowserTab(homeProvider.data['youtube_page']);
                      },
                      child: Container(
                        child: Image.asset(Img.get('img_social_youtube.png')),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Container(width: 10),
                    InkWell(
                      onTap: () {
                        openBrowserTab(homeProvider.data['twitter_page']);
                      },
                      child: Container(
                        child: Image.asset(Img.get('img_social_twitter.png')),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Container(width: 10),
                    InkWell(
                      onTap: () {
                        openBrowserTab(homeProvider.data['instagram_page']);
                      },
                      child: Container(
                        child: Image.asset(Img.get('img_social_instagram.png')),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 15),
          ],
        ),
      );
  }
}

class ItemTile extends StatelessWidget {
  final String title;
  final String thumbnail;
  final bool useAssetsImage;
  final String assetsImage;
  final HomeIndex index;
  final HomeProvider homeProvider;

  const ItemTile(
      {Key key,
      @required this.index,
      @required this.title,
      @required this.thumbnail,
      @required this.homeProvider,
      @required this.useAssetsImage,
      @required this.assetsImage})
      : assert(title != null),
        assert(thumbnail != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3.0, left: 3.00),
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: CachedNetworkImage(
                    imageUrl: thumbnail,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black12, BlendMode.darken)),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Center(
                        child: Image.asset(
                      assetsImage,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                      //color: Colors.black26,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 0.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  //color: Colors.black54,
                  height: 35,
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyles.caption(context).copyWith(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      //color: Colors.white,
                      fontFamily: "serif",
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          switch (index) {
            case HomeIndex.CATEGORIES:
              Navigator.of(context).pushNamed(CategoriesScreen.routeName);
              break;
            case HomeIndex.VIDEOS:
              Navigator.of(context).pushNamed(VideoScreen.routeName);
              break;
            case HomeIndex.AUDIOS:
              Navigator.of(context).pushNamed(AudioScreen.routeName);
              break;
            case HomeIndex.BIBLEBOOKS:
              Navigator.of(context).pushNamed(BibleScreen.routeName);
              break;
            case HomeIndex.LIVESTREAMS:
              Navigator.of(context).pushNamed(LivestreamsPlayer.routeName,
                  arguments: ScreenArguements(
                    position: 0,
                    items: homeProvider.data['livestream'],
                    itemsList: [],
                  ));
              break;
            case HomeIndex.RADIO:
              Radios radios = homeProvider.data['radios'];
              Media media = new Media(
                  id: radios.id,
                  title: radios.title,
                  coverPhoto: radios.coverPhoto,
                  streamUrl: radios.streamUrl);
              Provider.of<AudioPlayerModel>(context, listen: false)
                  .prepareradioplayer(media);
              //Navigator.of(context).pushNamed(RadioPlayer.routeName);
              break;
          }
        },
      ),
    );
  }
}
