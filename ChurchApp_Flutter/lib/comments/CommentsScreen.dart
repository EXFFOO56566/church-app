import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.g.dart';
import '../auth/LoginScreen.dart';
import '../widgets/CommentsItem.dart';
import '../models/Userdata.dart';
import '../models/Comments.dart';
import '../models/Media.dart';
import '../utils/my_colors.dart';
import '../providers/CommentsModel.dart';
import '../providers/AppStateManager.dart';
import '../widgets/CommentsMediaHeader.dart';

class CommentsScreen extends StatefulWidget {
  static String routeName = "/comments";
  final Media item;
  final int commentCount;

  CommentsScreen({Key key, this.item, this.commentCount}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.item.toString());
    final appState = Provider.of<AppStateManager>(context);
    Userdata userdata = appState.userdata;

    return ChangeNotifierProvider(
        create: (context) => CommentsModel(
            context, widget.item.id, userdata, widget.commentCount),
        child: CommentsSection(widget: widget, userdata: userdata));
  }
}

class CommentsSection extends StatelessWidget {
  const CommentsSection({
    Key key,
    @required this.widget,
    @required this.userdata,
  }) : super(key: key);

  final CommentsScreen widget;
  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context,
            Provider.of<CommentsModel>(context, listen: false)
                .totalPostComments);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(
                context,
                Provider.of<CommentsModel>(context, listen: false)
                    .totalPostComments),
          ),
          title: Text(t.comments),
        ),
        body: Column(
          children: <Widget>[
            CommentsMediaHeader(object: widget.item),
            Container(height: 5),
            Expanded(
              child: CommentsLists(),
            ),
            Divider(height: 0, thickness: 1),
            userdata == null
                ? Container(
                    height: 50,
                    child: Center(
                        child: ElevatedButton(
                            child: Text(t.logintoaddcomment),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
                            })),
                  )
                : Consumer<CommentsModel>(
                    builder: (context, commentsModel, child) {
                    return Row(
                      children: <Widget>[
                        Container(width: 10),
                        Expanded(
                          child: TextField(
                            controller: commentsModel.inputController,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration.collapsed(
                                hintText: t.writeamessage),
                          ),
                        ),
                        commentsModel.isMakingComment
                            ? Container(
                                width: 30, child: CupertinoActivityIndicator())
                            : IconButton(
                                icon: Icon(Icons.send,
                                    color: MyColors.primary, size: 20),
                                onPressed: () {
                                  String text =
                                      commentsModel.inputController.text;
                                  if (text != "") {
                                    commentsModel.makeComment(text);
                                  }
                                }),
                      ],
                    );
                  })
          ],
        ),
      ),
    );
  }
}

class CommentsLists extends StatelessWidget {
  const CommentsLists({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentsModel = Provider.of<CommentsModel>(context);
    List<Comments> commentsList = commentsModel.items;
    if (commentsModel.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    } else if (commentsList.length == 0) {
      return Center(
          child: Container(
        height: 200,
        child: GestureDetector(
          onTap: () {
            commentsModel.loadComments();
          },
          child: ListView(children: <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              t.nocomments,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else {
      return ListView.separated(
        controller: commentsModel.scrollController,
        itemCount: commentsModel.hasMoreComments
            ? commentsList.length + 1
            : commentsList.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          if (index == 0 && commentsModel.isLoadingMore) {
            return Container(
                width: 30, child: Center(child: CupertinoActivityIndicator()));
          } else if (index == 0 && commentsModel.hasMoreComments) {
            return Container(
              height: 30,
              child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20)),),
                      child: Text(t.loadmore),
                      onPressed: () {
                        Provider.of<CommentsModel>(context, listen: false)
                            .loadMoreComments();
                      })),
            );
          } else {
            int _index = index;
            if (commentsModel.hasMoreComments) _index = index - 1;
            return CommentsItem(
              isUser: commentsModel.isUser(commentsList[_index].email),
              context: context,
              index: _index,
              object: commentsList[_index],
            );
          }
        },
      );
    }
  }
}
