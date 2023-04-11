import 'package:churchapp_flutter/i18n/strings.g.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AppStateManager.dart';
import 'package:flutter/services.dart';
import './providers/translate_provider.dart';
import './utils/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'MyApp.dart';
import './providers/BibleModel.dart';
import './providers/BookmarksModel.dart';
import './providers/PlaylistsModel.dart';
import './providers/AudioPlayerModel.dart';
import './providers/HymnsBookmarksModel.dart';
import './providers/DownloadsModel.dart';
import './providers/NotesProvider.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import './providers/SubscriptionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/OnboardingPage.dart';
import './screens/HomePage.dart';
import 'providers/ChatManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  await Firebase.initializeApp();
  Admob.initialize();
  await FlutterDownloader.initialize(debug: true);
  InAppPurchaseConnection.enablePendingPurchases();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.primaryDark,
      statusBarBrightness: Brightness.light));

  Future<Widget> getFirstScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("user_seen_onboarding_page") == null ||
        prefs.getBool("user_seen_onboarding_page") == false) {
      return new OnboardingPage();
    } else {
      return HomePage();
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateManager()),
        ChangeNotifierProvider(create: (_) => BookmarksModel()),
        ChangeNotifierProvider(create: (_) => PlaylistsModel()),
        ChangeNotifierProvider(create: (_) => AudioPlayerModel()),
        ChangeNotifierProvider(create: (_) => DownloadsModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionModel()),
        ChangeNotifierProvider(create: (_) => HymnsBookmarksModel()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => BibleModel()),
        ChangeNotifierProvider(create: (_) => TranslateProvider()),
        ChangeNotifierProvider(create: (_) => ChatManager()),
      ],
      child: FutureBuilder<Widget>(
        future: getFirstScreen(), //returns bool
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp(defaultHome: snapshot.data);
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    ),
  );
}
