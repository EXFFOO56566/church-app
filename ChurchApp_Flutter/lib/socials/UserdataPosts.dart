import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Userdata.dart';
import '../models/UserPosts.dart';
import '../i18n/strings.g.dart';
import '../screens/NoitemScreen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/ApiUrl.dart';
import '../providers/AppStateManager.dart';
import '../screens/EmptyListScreen.dart';
import '../widgets/UserPostTile.dart';

class UserdataPosts extends StatefulWidget {
  static const routeName = "/userdataPosts";
  UserdataPosts({this.user});
  final Userdata user;

  @override
  PinnedPostsRouteState createState() => new PinnedPostsRouteState();
}

class PinnedPostsRouteState extends State<UserdataPosts> {
  List<UserPosts> items = [];
  bool isError = false;
  Userdata userdata;
  RefreshController refreshController;
  String query = "";
  int page = 0;

  void _onRefresh() async {
    loadItems();
  }

  void _onLoading() async {
    loadMoreItems();
  }

  loadItems() {
    page = 0;
    refreshController.requestRefresh();
    setState(() {});
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  editPostCallback(int index, String text) {
    items[index].content = text;
  }

  deletePostCallback(int index) {
    items.removeAt(index);
    setState(() {});
  }

  likePostCallback(int index, bool isLiked, int likesCount) {
    items[index].isLiked = isLiked;
    items[index].likesCount = likesCount;
  }

  pinPostCallback(int index, bool isPinned) {
    items[index].isPinned = isPinned;
  }

  void setItems(List<UserPosts> item) {
    items.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    setState(() {});
  }

  void setMoreItems(List<UserPosts> item) {
    items.addAll(item);
    refreshController.loadComplete();
    setState(() {});
  }

  Future<void> fetchItems() async {
    print(query);
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.
      var data = {
        "data": {
          "viewer": userdata.email,
          "page": page.toString(),
          "email": widget.user.email
        }
      };
      print(data);
      final response = await dio.post(
        ApiUrl.fetchUserdataPosts,
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.data);
        dynamic res = jsonDecode(response.data);
        List<UserPosts> postsList = parsePosts(res);
        if (page == 0) {
          setItems(postsList);
        } else {
          setMoreItems(postsList);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  static List<UserPosts> parsePosts(dynamic res) {
    //final res = jsonDecode(responseBody);
    final parsed = res["posts"].cast<Map<String, dynamic>>();
    return parsed.map<UserPosts>((json) => UserPosts.fromJson(json)).toList();
  }

  setFetchError() {
    if (page == 0) {
      isError = true;
      refreshController.refreshFailed();
      setState(() {});
    } else {
      refreshController.loadFailed();
      setState(() {});
    }
  }

  @override
  void initState() {
    refreshController = RefreshController(initialRefresh: false);
    Future.delayed(const Duration(milliseconds: 0), () {
      loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userdata = Provider.of<AppStateManager>(context).userdata;
    return Scaffold(
      appBar: AppBar(
        title: Text(userdata.email == widget.user.email
            ? t.my + " " + t.posts
            : widget.user.name + " " + t.posts),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 0),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text(t.pulluploadmore);
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text(t.loadfailedretry);
              } else if (mode == LoadStatus.canLoading) {
                body = Text(t.releaseloadmore);
              } else {
                body = Text(t.nomoredata);
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: (isError == true)
              ? NoitemScreen(
                  title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
              : (items.length == 0
                  ? EmptyListScreen(message: t.noitemstodisplay)
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 0.5,
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Divider(),
                          ),
                        );
                      },
                      itemCount: items.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        // print(items[index].coverPhoto);
                        return UserPostTile(
                          index: index,
                          object: items[index],
                          userdata: userdata,
                          likePostCallback: likePostCallback,
                          pinPostCallback: pinPostCallback,
                          isCommentsSection: false,
                          editPostCallback: editPostCallback,
                          deletePostCallback: deletePostCallback,
                          key: UniqueKey(),
                        );
                      },
                    )),
        ),
      ),
    );
  }
}
