import '../socials/PinnedPosts.dart';
import '../providers/AppStateManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserProfileScreen.dart';
import '../models/ScreenArguements.dart';
import '../models/Userdata.dart';
import '../utils/ApiUrl.dart';
import '../utils/Alerts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../i18n/strings.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen();

  @override
  SettingsRouteState createState() => new SettingsRouteState();
}

class SettingsRouteState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  bool phoneSwitch = false;
  bool dobSwitch = false, followSwitch = false;
  bool commentSwitch = false, likeSwitch = false;

  Future<void> loadItems(Userdata userdata) async {
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(ApiUrl.fetchUserSettings,
          data: jsonEncode({
            "data": {
              "email": userdata.email,
            }
          }));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.data);
        dynamic res = jsonDecode(response.data);
        setState(() {
          phoneSwitch = int.parse(res['user']['show_phone'].toString()) == 0;
          dobSwitch =
              int.parse(res['user']['show_dateofbirth'].toString()) == 0;
          followSwitch =
              int.parse(res['user']['notify_follows'].toString()) == 0;
          commentSwitch =
              int.parse(res['user']['notify_comments'].toString()) == 0;
          likeSwitch = int.parse(res['user']['notify_likes'].toString()) == 0;
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.

      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  Future<void> updateUserSettings(Userdata userdata) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.updateUserSettings,
        data: jsonEncode({
          "data": {
            "email": userdata.email,
            "show_dateofbirth": dobSwitch ? 0 : 1,
            "show_phone": phoneSwitch ? 0 : 1,
            "notify_follows": followSwitch ? 0 : 1,
            "notify_comments": commentSwitch ? 0 : 1,
            "notify_likes": likeSwitch ? 0 : 1
          }
        }),
      );
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.data);
        Map<String, dynamic> res = json.decode(response.data);
        if (res["status"] == "error") {
          Alerts.show(context, t.error, res["msg"]);
        } else {
          print(res["user"]);
          Alerts.show(context, t.success, res["msg"]);
        }
      }
    } catch (exception) {
      // I get no exception here
      Navigator.of(context).pop();
      Alerts.show(context, t.error, exception.toString());
      print(exception);
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      loadItems(Provider.of<AppStateManager>(context, listen: false).userdata);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Userdata userdata = Provider.of<AppStateManager>(context).userdata;

    return Scaffold(
      appBar:
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(0)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: Card(
                  margin: EdgeInsets.all(0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl: userdata.avatar,
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
                        child: Icon(
                          Icons.error,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  userdata.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(t.viewprofile),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    UserProfileScreen.routeName,
                    arguments: ScreenArguements(items: userdata),
                  );
                },
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: Card(
                  margin: EdgeInsets.all(0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Icon(
                      LineAwesomeIcons.pinterest,
                      size: 50,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  t.mypins,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(t.viewpinnedposts),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.pushNamed(context, PinnedPosts.routeName);
                },
              ),
            ),
            Divider(height: 0),
            Container(
              height: 30,
              //color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(t.personal,
                      style: TextStyles.subhead(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Container(
                    height: 35,
                    child: TextButton(
                      child: Text(
                        t.update,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        updateUserSettings(userdata);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                title: Text(
                  t.phonenumber,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(t.showmyphonenumber),
                trailing: Switch(
                  value: phoneSwitch,
                  onChanged: (value) {
                    setState(() {
                      phoneSwitch = value;
                    });
                  },
                  activeColor: MyColors.primary,
                  inactiveThumbColor: Colors.grey,
                ),
                onTap: () {},
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                title: Text(
                  t.dateofbirth,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(t.showmyfulldateofbirth),
                trailing: Switch(
                  value: dobSwitch,
                  onChanged: (value) {
                    setState(() {
                      dobSwitch = value;
                    });
                  },
                  activeColor: MyColors.primary,
                  inactiveThumbColor: Colors.grey,
                ),
                onTap: () {},
              ),
            ),
            Container(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(t.notifications,
                      style: TextStyles.subhead(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(4),
                title: Text(t.notifywhenuserfollowsme),
                trailing: Switch(
                  value: followSwitch,
                  onChanged: (value) {
                    setState(() {
                      followSwitch = value;
                    });
                  },
                  activeColor: MyColors.primary,
                  inactiveThumbColor: Colors.grey,
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(4),
                title: Text(t.notifymewhenusercommentsonmypost),
                trailing: Switch(
                  value: commentSwitch,
                  onChanged: (value) {
                    setState(() {
                      commentSwitch = value;
                    });
                  },
                  activeColor: MyColors.primary,
                  inactiveThumbColor: Colors.grey,
                ),
                onTap: () {},
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(4),
                title: Text(t.notifymewhenuserlikesmypost),
                trailing: Switch(
                  value: likeSwitch,
                  onChanged: (value) {
                    setState(() {
                      likeSwitch = value;
                    });
                  },
                  activeColor: MyColors.primary,
                  inactiveThumbColor: Colors.grey,
                ),
                onTap: () {},
              ),
            ),
            Divider(height: 0),
            Container(height: 25),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
