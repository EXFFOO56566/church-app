import '../utils/TimUtil.dart';
import 'package:flutter/rendering.dart';
import '../models/Chats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../i18n/strings.g.dart';
import '../providers/ChatManager.dart';
import '../screens/EmptyListScreen.dart';
import '../utils/my_colors.dart';
import 'SelectChatPeople.dart';
import '../providers/events.dart';
import '../models/UserEvents.dart';
import 'ChatConversations.dart';

class ChatUsersScreen extends StatefulWidget {
  ChatUsersScreen();

  @override
  ChatUsersScreenRouteState createState() => new ChatUsersScreenRouteState();
}

class ChatUsersScreenRouteState extends State<ChatUsersScreen> {
  ChatManager chatManager;
  List<Chats> items;
  ScrollController controller;
  bool fabIsVisible = true;

  void _onRefresh() async {
    chatManager.loadItems();
  }

  void _onLoading() async {
    chatManager.loadMoreItems();
  }

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        fabIsVisible =
            controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatManager = Provider.of<ChatManager>(context);
    items = chatManager.userChatsList;
    print(" chat users list = " + items.length.toString());
    return Scaffold(
      body: SmartRefresher(
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
        controller: chatManager.refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: (chatManager.isError == true || items.length == 0)
            ? EmptyListScreen(
                message: t.nochatsavailable,
              )
            : ListView.separated(
                itemCount: items.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(3),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  return _ChatItem(
                    key: UniqueKey(),
                    index: index,
                    chats: items[index],
                  );
                },
              ),
      ),
      floatingActionButton: AnimatedOpacity(
        child: FloatingActionButton(
          backgroundColor: MyColors.primary,
          onPressed: () {
            Navigator.of(context).pushNamed(SelectChatPeople.routeName);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
        duration: Duration(milliseconds: 100),
        opacity: fabIsVisible ? 1 : 0,
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  final Key key;
  final Chats chats;
  final int index;
  _ChatItem({this.chats, this.index, this.key}) : super(key: key);

  Widget _activeIcon(isActive) {
    if (isActive) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3),
          width: 16,
          height: 16,
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Color(0xff43ce7d), // flat green
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        eventBus.fire(StartPartnerChatEvent(chats.partner));
        Navigator.pushNamed(
          context,
          ChatConversations.routeName,
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 12.0),
              child: Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      eventBus.fire(StartPartnerChatEvent(chats.partner));
                      Navigator.pushNamed(
                        context,
                        ChatConversations.routeName,
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(chats.partner.avatar),
                      radius: 30.0,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: _activeIcon(chats.isOnline == 0),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 6.0, right: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        chats.partner.name,
                        style: TextStyle(fontSize: 18),
                      ),
                      chats.isTyping
                          ? Container(
                              margin: EdgeInsets.only(top: 4.0),
                              child: Text(
                                t.typing,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 4.0),
                              child: chats.chatMessages.length > 0
                                  ? (chats.chatMessages[0].message != "")
                                      ? Text(chats.chatMessages[0].message,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              height: 1.1),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis)
                                      : Row(
                                          children: [
                                            Container(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.photo,
                                              size: 22,
                                            ),
                                            Container(
                                              width: 4,
                                            ),
                                            Text(
                                              t.photo,
                                              style: TextStyle(fontSize: 14),
                                            )
                                          ],
                                        )
                                  : Container(),
                            )
                    ],
                  )),
            ),
            Column(
              children: <Widget>[
                chats.chatMessages.length > 0
                    ? Text(TimUtil.timeAgoSinceDate(chats.chatMessages[0].date),
                        style: TextStyle(color: Colors.grey[350]))
                    : Container(),
                _UnreadIndicator(chats.unseen),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _UnreadIndicator extends StatelessWidget {
  final int unread;

  _UnreadIndicator(this.unread);

  @override
  Widget build(BuildContext context) {
    if (unread == 0) {
      return Container(); // return empty container
    } else {
      return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 30,
                color: MyColors.primary,
                width: 30,
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Text(
                  unread > 9 ? "9+" : unread.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )));
    }
  }
}
