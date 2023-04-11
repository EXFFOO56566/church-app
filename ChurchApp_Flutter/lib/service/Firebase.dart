import 'dart:convert';
import 'dart:async';
import '../models/Userdata.dart';
import '../models/Inbox.dart';
import '../models/LiveStreams.dart';
import '../models/ChatMessages.dart';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Media.dart';
import '../utils/my_colors.dart';
import '../providers/events.dart';
import '../models/UserEvents.dart';
import 'dart:math';

var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  Firebase.myBackgroundMessageHandler(message.data);
}

class Firebase {
  Function navigateMedia;
  Function navigateSocials;
  Function navigateInbox;
  Function navigateLivestreams;
  Function navigateChat;
  static String appState = "idle";

  Firebase(
    Function navigateMedia,
    Function navigateSocials,
    Function navigateInbox,
    Function navigateLivestreams,
    Function navigateChat,
  ) {
    this.navigateMedia = navigateMedia;
    this.navigateSocials = navigateSocials;
    this.navigateLivestreams = navigateLivestreams;
    this.navigateInbox = navigateInbox;
    this.navigateChat = navigateChat;
  }

  //updated myBackgroundMessageHandler
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    handleNotificationMessages(message);
    return Future<void>.value();
  }

  void init() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelect);

    FirebaseMessaging.onMessage.listen((message) async {
      print("onMessage: $message");
      handleNotificationMessages(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getToken().then((token) async {
      print("Push Messaging token: $token");
      sendFirebaseTokenToServer(token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("firebase_token", token);
    });

    /*final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onMessage: (message) async {
        print("onMessage: $message");
        handleNotificationMessages(message);
      },
      onLaunch: (message) async {
        print("onLaunch: $message");
      },
      onResume: (message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.getToken().then((String token) async {
      print("Push Messaging token: $token");
      sendFirebaseTokenToServer(token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("firebase_token", token);
    });*/
    initEvents();
  }

  static initEvents() async {
    eventBus.on<OnAppStateChanged>().listen((event) {
      appState = event.state;
      print("OnAppStateChanged event called = " + appState);
    });
  }

  static handleNotificationMessages(Map<String, dynamic> message) {
    print("myBackgroundMessageHandler message1: $message");
    var data = message;
    //['data'];
    /*if (data == null) {
      data = message;
    }*/
    print("myBackgroundMessageHandler message: $data");
    var action = data["action"];
    String title = "";
    String msg = "";
    if (action == "newMedia") {
      Map<String, dynamic> arts = json.decode(data['media']);
      Media articles = Media.fromJson(arts);
      title = articles.description;
      msg = articles.title;
    }

    if (action == "social_notify") {
      String title = data["title"];
      String message = data["message"];
      title = message;
      msg = title;
    }

    if (action == "inbox") {
      Map<String, dynamic> arts = json.decode(data['inbox']);
      Inbox inbox = Inbox.fromJson(arts);
      title = inbox.message;
      msg = inbox.title;
    }

    if (action == "livestream") {
      Map<String, dynamic> livestream = json.decode(data['livestream']);
      LiveStreams liveStreams = LiveStreams.fromJson(livestream);
      title = liveStreams.description;
      msg = liveStreams.title;
    }

    if (action == "read_conversation") {
      String partner = data['email'];
      eventBus.fire(OnUserReadConversation(partner));
      return;
    }

    if (action == "user_typing") {
      String partner = data['email'];
      eventBus.fire(OnUserTyping(partner));
      return;
    }

    if (action == "online_status") {
      String partner = data['email'];
      int status = int.parse(data['status']);
      int lastSeen = int.parse(data['last_seen']);
      eventBus.fire(OnUserOnlineStatus(partner, status, lastSeen));
      return;
    }

    if (action == "chat") {
      Map<String, dynamic> _chat = json.decode(data['chat']);
      Map<String, dynamic> _user = json.decode(data['user']);
      ChatMessages chat = ChatMessages.fromJson(_chat);
      Userdata sender = Userdata.fromFCMJson(_user);
      title = sender.name;
      msg = chat.message;
      eventBus
          .fire(OnReceiveChatConversation(chat, sender, msg, message, true));
      if (msg == "") {
        msg = "Sent a Photo";
      }
      //print(title + " and " + msg);
      if (appState == "active") {
        return;
      }
      chatNotification(message, title, msg);
      return;
    }

    if (title != "" && msg != "") {
      BigTextStyleInformation bigTextStyleInformation =
          BigTextStyleInformation(msg, contentTitle: title);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'churchapp', 'churchapp', 'church_app',
          color: MyColors.primary,
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigTextStyleInformation,
          ticker: title);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      flutterLocalNotificationsPlugin.show(
          102, title, msg, platformChannelSpecifics,
          payload: json.encode(message));
    }
  }

  static chatNotification(
      Map<String, dynamic> message, String name, String title) {
    List<String> lines = <String>[
      title,
    ];
    InboxStyleInformation inboxStyleInformation =
        InboxStyleInformation(lines, contentTitle: name, summaryText: title);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'churchapp', 'churchapp', 'church_app',
        color: MyColors.primary,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: inboxStyleInformation,
        ticker: name);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
        new Random().nextInt(100000), name, title, platformChannelSpecifics,
        payload: json.encode(message));
  }

  Future<String> onSelect(String itm) async {
    print("onSelectNotification $itm");
    Map<String, dynamic> message = json.decode(itm);
    var data = message;
    //['data'];
    /*if (data == null) {
      data = message;
    }*/
    var action = data["action"];
    print("pushNotification = " + action);
    if (action == "newMedia") {
      Map<String, dynamic> arts = json.decode(data['media']);
      Media media = Media.fromJson(arts);
      navigateMedia(media);
    }
    if (action == "social_notify") {
      navigateSocials();
    }

    if (action == "inbox") {
      navigateInbox();
    }

    if (action == "livestream") {
      Map<String, dynamic> livestream = json.decode(data['livestream']);
      LiveStreams liveStreams = LiveStreams.fromJson(livestream);
      navigateLivestreams(liveStreams);
    }

    if (action == "chat") {
      Map<String, dynamic> _user = json.decode(data['user']);
      Userdata sender = Userdata.fromFCMJson(_user);
      navigateChat(sender);
    }

    return null;
  }

  sendFirebaseTokenToServer(String token) async {
    bool status = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("token_sent_to_server") != null) {
      status = prefs.getBool("token_sent_to_server");
    }
    if (status == false) {
      print("Firebase token not yet sent to server");

      var data = {"token": token, "version": "v2"};
      print(data.toString());
      try {
        final response = await http.post(Uri.parse(ApiUrl.storeFcmToken),
            body: jsonEncode({"data": data}));
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.
          print(response.body);
          Map<String, dynamic> res = json.decode(response.body);
          if (res["status"] == "ok") {
            prefs.setBool("token_sent_to_server", true);
          }
        }
      } catch (exception) {
        // I get no exception here
        print(exception);
      }
    } else {
      print("Firebase token sent to server");
    }
  }
}
