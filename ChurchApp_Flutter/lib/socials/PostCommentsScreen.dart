import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.g.dart';
import '../auth/LoginScreen.dart';
import '../widgets/PostCommentsItem.dart';
import '../models/Userdata.dart';
import '../models/UserPosts.dart';
import '../utils/my_colors.dart';
import '../providers/PostsCommentsModel.dart';
import '../providers/AppStateManager.dart';
import '../widgets/UserPostTile.dart';
import '../models/Comments.dart';

class PostCommentsScreen extends StatefulWidget {
  static String routeName = "/postcomments";
  final UserPosts userPosts;

  PostCommentsScreen({Key key, this.userPosts}) : super(key: key);

  @override
  _PostCommentsScreenState createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateManager>(context);
    Userdata userdata = appState.userdata;

    return ChangeNotifierProvider(
        create: (context) => PostsCommentsModel(context, widget.userPosts.id,
            widget.userPosts.email, userdata, widget.userPosts.commentsCount),
        child: CommentsSection(widget: widget, userdata: userdata));
  }
}

class CommentsSection extends StatelessWidget {
  const CommentsSection({
    Key key,
    @required this.widget,
    @required this.userdata,
  }) : super(key: key);

  final PostCommentsScreen widget;
  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    UserPosts _userPosts = widget.userPosts;

    return WillPopScope(
      onWillPop: () async {
        _userPosts.commentsCount =
            Provider.of<PostsCommentsModel>(context, listen: false)
                .totalPostComments;
        Navigator.pop(context, _userPosts);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              _userPosts.commentsCount =
                  Provider.of<PostsCommentsModel>(context, listen: false)
                      .totalPostComments;
              Navigator.pop(context, _userPosts);
            },
          ),
          title: Text(t.postdetails),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Consumer<PostsCommentsModel>(
                        builder: (context, commentsModel, child) {
                      return UserPostTile(
                        index: 0,
                        object: widget.userPosts,
                        userdata: userdata,
                        likePostCallback: (UserPosts userPosts, bool isLiked,
                            int likesCount) {
                          _userPosts.isLiked = isLiked;
                          _userPosts.likesCount = likesCount;
                        },
                        pinPostCallback: (UserPosts userPosts, bool isPinned) {
                          _userPosts.isPinned = isPinned;
                        },
                        editPostCallback: (_, __) {},
                        deletePostCallback: (_) {},
                        isCommentsSection: true,
                        commentsCount: commentsModel.totalPostComments,
                        key: UniqueKey(),
                      );
                    }),
                    Divider(height: 0, thickness: 1),
                    Container(height: 5),
                    CommentsLists(),
                  ],
                ),
              ),
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
                : Consumer<PostsCommentsModel>(
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
                                width: 30,
                                height: 50,
                                child: CupertinoActivityIndicator())
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
    var commentsModel = Provider.of<PostsCommentsModel>(context);
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
        shrinkWrap: true,
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
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                      ),
                      child: Text(t.loadmore),
                      onPressed: () {
                        Provider.of<PostsCommentsModel>(context, listen: false)
                            .loadMoreComments();
                      })),
            );
          } else {
            int _index = index;
            if (commentsModel.hasMoreComments) _index = index - 1;
            return PostCommentsItem(
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
