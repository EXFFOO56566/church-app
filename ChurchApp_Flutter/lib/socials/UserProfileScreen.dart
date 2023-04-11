import '../socials/UserFollowersScreen.dart';
import '../socials/UpdateUserProfile.dart';
import '../socials/UserdataPosts.dart';
import '../utils/Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../models/ScreenArguements.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';
import '../utils/img.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateManager.dart';
import '../utils/ApiUrl.dart';
import '../i18n/strings.g.dart';
import '../models/Userdata.dart';
import '../screens/NoitemScreen.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfileScreen extends StatefulWidget {
  static String routeName = "/userprofile";
  UserProfileScreen({this.user});
  final Userdata user;

  @override
  UserProfileScreenRouteState createState() =>
      new UserProfileScreenRouteState();
}

class UserProfileScreenRouteState extends State<UserProfileScreen> {
  bool isError = false;
  bool isLoading = true;
  Userdata userdata;
  Userdata _user;
  int postscount = 0;
  int followerscount = 0;
  int followingscount = 0;
  bool isFollowing = false;

  Future<void> fetchItems(Userdata userdata) async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.userBioInfoFlutter,
        data: jsonEncode({
          "data": {"email": widget.user.email, "viewer": userdata.email}
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.data);
        dynamic res = jsonDecode(response.data);
        _user = Userdata.fromJsonActivated(res['user']);
        postscount = int.parse(res['post_count'].toString());
        followerscount = int.parse(res['followers_count'].toString());
        followingscount = int.parse(res['following_count'].toString());
        isFollowing = int.parse(res['isFollowing'].toString()) == 0;
        isLoading = false;
        isError = false;
        setState(() {});
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        isLoading = false;
        isError = true;
        setState(() {});
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      isLoading = false;
      isError = true;
      setState(() {});
    }
  }

  Future<void> followUnfollowUser() async {
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.
      var data = {
        "data": {
          "user": _user.email,
          "follower": userdata.email,
          "action": isFollowing ? "unfollow" : "follow"
        }
      };
      setState(() {
        isFollowing = isFollowing ? false : true;
        if (isFollowing)
          followerscount++;
        else
          followerscount--;
      });

      final response = await dio.post(
        ApiUrl.followUnfollowUser,
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.data);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  @override
  void initState() {
    _user = widget.user;
    Future.delayed(const Duration(milliseconds: 0), () {
      fetchItems(Provider.of<AppStateManager>(context, listen: false).userdata);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userdata = Provider.of<AppStateManager>(context).userdata;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 220.0,
              flexibleSpace: FlexibleSpaceBar(
                background: _user.coverPhoto == ""
                    ? Image.asset(Img.get('cover_photos.jpg'),
                        fit: BoxFit.cover)
                    : CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: _user.coverPhoto,
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
                            Img.get('cover_photos.jpg'),
                          ),
                        ),
                      ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Container(
                  transform: Matrix4.translationValues(0, 50, 0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: _user.avatar == ""
                        ? CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(Img.get("avatar.png")),
                          )
                        : Card(
                            margin: EdgeInsets.all(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl: _user.avatar,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Img.get('avatar.png'),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: getProfileBody(),
      ),
    );
  }

  Widget getProfileBody() {
    if (isLoading) {
      return Container(
        height: 400,
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    if (isError) {
      return NoitemScreen(
          title: t.error,
          message: t.pleaseclicktoretry,
          onClick: () {
            fetchItems(userdata);
          });
    }
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Container(height: 70),
            Text(_user.name,
                style: TextStyles.headline(context)
                    .copyWith(fontWeight: FontWeight.bold)),
            Container(height: 15),
            _user.aboutMe == ""
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : Text(Utility.getBase64DecodedString(_user.aboutMe),
                    textAlign: TextAlign.center,
                    style: TextStyles.subhead(context).copyWith()),
            Container(height: 4),
            userdata.email == _user.email
                ? ElevatedButton(
                    child: Text(
                      t.updateprofile.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: MyColors.accent,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, UpdateUserProfile.routeName,
                          arguments: ScreenArguements(
                            check: false,
                          ));
                    },
                  )
                : (isFollowing
                    ? ElevatedButton(
                        child: Text(
                          t.unfollow.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.accent,
                        ),
                        onPressed: () {
                          followUnfollowUser();
                        },
                      )
                    : ElevatedButton(
                        child: Text(
                          t.follow.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.accent,
                        ),
                        onPressed: () {
                          followUnfollowUser();
                        },
                      )),
            Container(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        UserdataPosts.routeName,
                        arguments: ScreenArguements(items: _user),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Text(postscount.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(height: 5),
                        Text(t.posts,
                            style: TextStyles.subhead(context).copyWith())
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, UserFollowersScreen.routeName,
                          arguments: ScreenArguements(
                              check: false, items: _user, option: "followers"));
                    },
                    child: Column(
                      children: <Widget>[
                        Text(followerscount.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(height: 5),
                        Text(t.followers,
                            style: TextStyles.subhead(context).copyWith())
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, UserFollowersScreen.routeName,
                          arguments: ScreenArguements(
                              check: false, items: _user, option: "following"));
                    },
                    child: Column(
                      children: <Widget>[
                        Text(followingscount.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(height: 5),
                        Text(t.followings,
                            style: TextStyles.subhead(context).copyWith())
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: Icon(Icons.person),
                contentPadding: EdgeInsets.all(5),
                title: Text(
                  t.gender,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_user.gender),
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: Icon(Icons.date_range),
                contentPadding: EdgeInsets.all(5),
                title: Text(
                  t.dateofbirth,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_user.dateOfBirth),
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: Icon(Icons.email),
                contentPadding: EdgeInsets.all(5),
                title: Text(
                  t.emailaddress,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_user.email),
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: Icon(Icons.phone),
                contentPadding: EdgeInsets.all(5),
                title: Text(
                  t.phonenumber,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_user.phone == "" ? "-------" : _user.phone),
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: Icon(Icons.location_city),
                contentPadding: EdgeInsets.all(5),
                title: Text(
                  t.location,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_user.location),
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                leading: Icon(Icons.work),
                title: Text(
                  t.qualification,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    _user.qualification == "" ? "-----" : _user.qualification),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                leading: Icon(LineAwesomeIcons.facebook),
                title: Text(
                  t.facebookprofilelink,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_user.facebook == "" ? "-----" : _user.facebook),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                leading: Icon(LineAwesomeIcons.twitter),
                title: Text(
                  t.twitterprofilelink,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_user.twitter == "" ? "-----" : _user.twitter),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                leading: Icon(LineAwesomeIcons.linkedin),
                title: Text(
                  t.linkdln,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_user.linkdln == "" ? "-----" : _user.linkdln),
              ),
            ),
            Container(height: 35),
          ],
        ),
      ),
    );
  }
}
