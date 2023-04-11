import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Userdata.dart';
import '../i18n/strings.g.dart';
import '../screens/NoitemScreen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/EmptyListScreen.dart';
import '../utils/ApiUrl.dart';
import '../providers/AppStateManager.dart';
import '../socials/utils.dart';
import '../providers/events.dart';
import '../models/UserEvents.dart';
import 'ChatConversations.dart';

class SelectChatPeople extends StatefulWidget {
  static const routeName = "/SelectChatPeople";
  SelectChatPeople();

  @override
  SelectChatPeopleRouteState createState() => new SelectChatPeopleRouteState();
}

class SelectChatPeopleRouteState extends State<SelectChatPeople> {
  List<Userdata> items = [];
  List<String> followUsers = [];
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
    followUsers = [];
    setState(() {});
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Userdata> item) {
    items.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    setState(() {});
  }

  void setMoreItems(List<Userdata> item) {
    items.addAll(item);
    refreshController.loadComplete();
    setState(() {});
  }

  Future<void> fetchItems() async {
    print(query);
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.getUsersToFollow,
        data: jsonEncode({
          "data": {
            "email": userdata.email,
            "page": page.toString(),
            "query": query
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.data);
        dynamic res = jsonDecode(response.data);
        List<Userdata> userList = parseUsers(res);
        if (page == 0) {
          setItems(userList);
        } else {
          setMoreItems(userList);
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

  static List<Userdata> parseUsers(dynamic res) {
    //final res = jsonDecode(responseBody);
    final parsed = res["users"].cast<Map<String, dynamic>>();
    return parsed.map<Userdata>((json) => Userdata.fromJson2(json)).toList();
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
        title: TextField(
          onChanged: (value) {
            if (value.length == 0) {
              query = "";
              loadItems();
            }
          },
          onSubmitted: (value) {
            query = value;
            loadItems();
          },
          style: TextStyle(color: Colors.white, fontSize: 18),
          cursorColor: Colors.white,
          decoration: InputDecoration.collapsed(
            hintStyle: TextStyle(color: Colors.white, fontSize: 18),
            hintText: t.searchforpeople,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
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
                      padding: EdgeInsets.all(3),
                      itemBuilder: (BuildContext context, int index) {
                        // print(items[index].coverPhoto);
                        return PeopleList(
                          object: items[index],
                          userdata: userdata,
                        );
                      },
                    )),
        ),
      ),
    );
  }
}

class PeopleList extends StatefulWidget {
  final Userdata object;
  final Userdata userdata;

  const PeopleList({
    Key key,
    @required this.object,
    @required this.userdata,
  })  : assert(object != null),
        super(key: key);

  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              imageUrl: widget.object.avatar,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black12, BlendMode.darken)),
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
        title: getUserName(context, widget.object, isClickable: false),
        subtitle: Text(widget.object.location),
        onTap: () {
          eventBus.fire(StartPartnerChatEvent(widget.object));
          Navigator.pushReplacementNamed(
            context,
            ChatConversations.routeName,
          );
        },
      ),
    );
  }
}
