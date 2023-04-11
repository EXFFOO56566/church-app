import '../socials/MakePostScreen.dart';
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
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/ApiUrl.dart';
import '../providers/AppStateManager.dart';
import '../screens/EmptyListScreen.dart';
import '../widgets/UserPostTile.dart';

class UserPostsSection extends StatefulWidget {
  UserPostsSection();

  @override
  UserPostsSectionRouteState createState() => new UserPostsSectionRouteState();
}

class UserPostsSectionRouteState extends State<UserPostsSection>
    with AutomaticKeepAliveClientMixin {
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
    setState(() {});
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
        "data": {"email": userdata.email, "page": page.toString()}
      };
      print(data);
      final response = await dio.post(
        ApiUrl.fetchUserPosts,
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
    super.build(context);
    userdata = Provider.of<AppStateManager>(context).userdata;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 0),
        child: Column(
          children: [
            Container(height: 5),
            InkWell(
              onTap: () async {
                final result = await Navigator.pushNamed(
                    context, MakePostScreen.routeName);
                if (result) {
                  loadItems();
                }
              },
              child: Row(
                children: [
                  Card(
                    margin: EdgeInsets.all(10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 30,
                      width: 30,
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
                  Expanded(
                    child: Container(
                      height: 45,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
                          child: TextField(
                            enabled: false,
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(fontSize: 16),
                              hintText: t.shareyourthoughts,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.insert_photo,
                      size: 30,
                    ),
                  ),
                  Container(width: 5, height: 50),
                ],
              ),
            ),
            Divider(),
            Expanded(
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
                        title: t.oops,
                        message: t.dataloaderror,
                        onClick: _onRefresh)
                    : (items.length == 0
                        ? EmptyListScreen(message: t.noitemstodisplay)
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 0.5,
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
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
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
