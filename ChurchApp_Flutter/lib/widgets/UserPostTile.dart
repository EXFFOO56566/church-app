import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../utils/my_colors.dart';
import '../utils/Utility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/CommentsArguement.dart';
import '../socials/PostCommentsScreen.dart';
import '../socials/likesPostPeople.dart';
import '../models/ScreenArguements.dart';
import '../utils/TimUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/Userdata.dart';
import '../models/UserPosts.dart';
import '../i18n/strings.g.dart';
import '../socials/PostImageViewer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/ApiUrl.dart';
import '../providers/AppStateManager.dart';
import '../widgets/ReadMoreText.dart';
import '../socials/PostVideoPlayer.dart';
import '../utils/img.dart';
import '../socials/utils.dart';
import '../socials/PostPopupMenu.dart';

class UserPostTile extends StatefulWidget {
  final int index;
  final UserPosts object;
  final Userdata userdata;
  final Function likePostCallback;
  final Function pinPostCallback;
  final Function editPostCallback;
  final Function deletePostCallback;
  final bool isCommentsSection;
  final int commentsCount;

  const UserPostTile(
      {Key key,
      @required this.index,
      @required this.object,
      @required this.userdata,
      @required this.likePostCallback,
      @required this.pinPostCallback,
      @required this.editPostCallback,
      @required this.deletePostCallback,
      @required this.isCommentsSection,
      this.commentsCount})
      : assert(object != null),
        super(key: key);

  @override
  _UserPostTileState createState() => _UserPostTileState();
}

class _UserPostTileState extends State<UserPostTile> {
  bool isLiked = false;
  bool isPinned = false;
  int likesCount = 0;
  int commentsCount = 0;
  final TextEditingController editController = new TextEditingController();

  final _pageController = PageController();
  int currentPage = 1;

  Future<void> likeposts() async {
    try {
      final dio = Dio();

      var data = {
        "data": {
          "id": widget.object.id,
          "user": widget.object.email,
          "email": widget.userdata.email,
          "action": isLiked ? "unlike" : "like"
        }
      };
      setState(() {
        isLiked = isLiked ? false : true;
        if (isLiked) {
          likesCount = likesCount + 1;
        } else {
          likesCount = likesCount - 1;
        }
        widget.likePostCallback(widget.index, isLiked, likesCount);
      });
      print(data);
      final response = await dio.post(
        ApiUrl.likeunlikepost,
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

  Future<void> pinpost() async {
    try {
      final dio = Dio();

      var data = {
        "data": {
          "id": widget.object.id,
          "email": widget.userdata.email,
          "action": isPinned ? "unpin" : "pin"
        }
      };
      setState(() {
        isPinned = isPinned ? false : true;
      });
      widget.pinPostCallback(widget.index, isPinned);
      print(data);
      final response = await dio.post(
        ApiUrl.pinunpinpost,
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

  Future<void> editPost() async {
    editController.text = widget.object.content;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(Strings.edit_comment_alert),
          content: SingleChildScrollView(
            child: TextFormField(
              controller: editController,
              maxLines: 5,
              minLines: 1,
              autofocus: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(t.cancel),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text(t.save),
                onPressed: () {
                  String text = editController.text;
                  if (text != "") {
                    Navigator.of(context).pop();
                    editPostServer(text);
                  }
                }),
          ],
        );
      },
    );
  }

  Future<void> editPostServer(String txt) async {
    try {
      final dio = Dio();

      var data = {
        "data": {
          "id": widget.object.id,
          "content": Utility.getBase64EncodedString(txt),
          "visibility": "public"
        }
      };

      widget.editPostCallback(widget.index, txt);
      print(data);
      final response = await dio.post(
        ApiUrl.editPost,
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

  Future<void> deletePost() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(t.deletepost),
              content: new Text(t.deleteposthint),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deletePostServer();
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> deletePostServer() async {
    try {
      final dio = Dio();

      var data = {
        "data": {
          "id": widget.object.id,
        }
      };

      widget.deletePostCallback(widget.index);
      print(data);
      final response = await dio.post(
        ApiUrl.deletePost,
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        //print(response.data);
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
    }
  }

  @override
  void initState() {
    isLiked = widget.object.isLiked;
    isPinned = widget.object.isPinned;
    likesCount = widget.object.likesCount;
    if (widget.isCommentsSection) {
      commentsCount = widget.commentsCount;
    } else {
      commentsCount = widget.object.commentsCount;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.object.media);
    return Card(
      elevation: 0.0,

      //clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Card(
                        margin: EdgeInsets.all(0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          height: 40,
                          width: 40,
                          child: CachedNetworkImage(
                            imageUrl: widget.object.avatar,
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
                      Container(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          getUserName(
                              context,
                              new Userdata(
                                  email: widget.object.email,
                                  name: widget.object.name,
                                  avatar: widget.object.avatar,
                                  coverPhoto: widget.object.coverPhoto)),
                          Container(height: 0),
                          Text(
                            TimUtil.timeAgo(widget.object.timestamp),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Spacer(),
                      (widget.object.email == widget.userdata.email &&
                              !widget.isCommentsSection)
                          ? PostPopupMenu(widget.object, editPost, deletePost)
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ],
                  ),
                ),
                Container(height: 0),
                widget.object.media.length == 0
                    ? Container()
                    : Stack(
                        children: [
                          Container(
                            height: 300,
                            child: PageView.builder(
                              onPageChanged: (int index) {
                                setState(() {
                                  currentPage = index + 1;
                                });
                              },
                              controller: _pageController,
                              itemBuilder: (context, position) {
                                String ext = Utility.getFileExtension(
                                    widget.object.media[position]);
                                print("extension is = " + ext);
                                if (ext == "mp4")
                                  return PostVideoPlayer(
                                    videoURL: widget.object.media[position],
                                  );
                                else
                                  return PostImageViewer(
                                    imgURL: widget.object.media[position],
                                  );
                              },
                              itemCount:
                                  widget.object.media.length, // Can be null
                            ),
                          ),
                          widget.object.media.length < 2
                              ? Container()
                              : Positioned(
                                  top: 15,
                                  right: 10,
                                  child: Container(
                                    height: 30,
                                    width: 60,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      margin: EdgeInsets.all(0),
                                      color: Colors.black45,
                                      elevation: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            currentPage.toString() +
                                                "/" +
                                                widget.object.media.length
                                                    .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                widget.object.media.length < 2
                    ? Container()
                    : Row(
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SmoothPageIndicator(
                                controller: _pageController, // PageController
                                count: widget.object.media.length,
                                effect: WormEffect(
                                    dotHeight: 6,
                                    dotWidth: 6,
                                    dotColor: Colors.grey,
                                    activeDotColor: MyColors
                                        .primary), // your preferred effect
                                onDotClicked: (index) {}),
                          ),
                          Spacer(),
                        ],
                      ),
                widget.object.content == ""
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(12),
                        child: ReadMoreText(
                          widget.object.content,
                          style: TextStyle(fontSize: 18),
                          trimLines: 5,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: t.readmore,
                          trimExpandedText: t.less,
                        ),
                      ),
              ],
            ),
          ),
          Container(
            height: 55,
            child: Row(
              children: <Widget>[
                Container(width: 12),
                InkWell(
                  onTap: () {
                    likeposts();
                  },
                  child: Icon(
                    LineAwesomeIcons.thumbs_up,
                    size: 28,
                    color: isLiked
                        ? Colors.pink
                        : (Provider.of<AppStateManager>(context, listen: false)
                                    .preferredTheme ==
                                1
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                Container(
                  width: 2,
                ),
                likesCount == 0
                    ? Container()
                    : InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, LikesPostPeople.routeName,
                              arguments: ScreenArguements(
                                items: widget.object,
                              ));
                        },
                        child: Text(likesCount.toString() + t.likess,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                      ),
                Container(width: 15),
                InkWell(
                  onTap: () async {
                    if (!widget.isCommentsSection) {
                      var userPosts = await Navigator.pushNamed(
                        context,
                        PostCommentsScreen.routeName,
                        arguments: CommentsArguement(item: widget.object),
                      );
                      setState(() {
                        isLiked = (userPosts as UserPosts).isLiked;
                        isPinned = (userPosts as UserPosts).isPinned;
                        likesCount = (userPosts as UserPosts).likesCount;
                        commentsCount = (userPosts as UserPosts).commentsCount;
                      });
                    }
                  },
                  child: Icon(LineAwesomeIcons.comment, size: 26),
                ),
                commentsCount == 0
                    ? Container()
                    : Text(commentsCount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        )),
                Spacer(),
                InkWell(
                  onTap: () {
                    pinpost();
                  },
                  child: Image.asset(
                    Img.get("pins.png"),
                    height: 26,
                    color: isPinned
                        ? Colors.pink
                        : (Provider.of<AppStateManager>(context, listen: false)
                                    .preferredTheme ==
                                1
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                Container(width: 15),
              ],
            ),
          ),
          Container(height: 15),
        ],
      ),
    );
  }
}
