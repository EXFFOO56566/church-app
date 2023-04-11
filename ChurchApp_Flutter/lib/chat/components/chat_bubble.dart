import 'dart:math';
import '../../providers/ChatManager.dart';
import 'package:provider/provider.dart';
import '../../i18n/strings.g.dart';
import 'dart:io';
import '../../widgets/ReadMoreText.dart';
import '../../utils/TimUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/Userdata.dart';
import 'package:flutter/material.dart';
import '../../models/ChatMessages.dart';
import '../../models/ScreenArguements.dart';
import '../photoviewer.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessages chatMessages;
  final Userdata userdata;
  final String recipient;
  final bool isThisChatSelected;

  ChatBubble(
      {Key key,
      @required this.chatMessages,
      this.userdata,
      @required this.isThisChatSelected,
      @required this.recipient})
      : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);
  bool isMe = false;
  String type = "text";

  @override
  void initState() {
    isMe = widget.chatMessages.sender == widget.userdata.email;
    type = widget.chatMessages.message != "" ? "text" : "image";
    super.initState();
  }

  Color chatBubbleColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey[800];
    } else {
      return Colors.grey[200];
    }
  }

  Color chatSelectedColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.white38;
    } else {
      return Colors.black26;
    }
  }

  Color chatBubbleReplyColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.grey[800];
    }
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(0.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );
    return InkWell(
      onTap: () {
        if (Provider.of<ChatManager>(context, listen: false)
                .selectedChatMessages
                .length ==
            0) return;
        if (widget.isThisChatSelected) {
          Provider.of<ChatManager>(context, listen: false)
              .unSelectChatMessage(widget.chatMessages.msgReciept);
        } else {
          Provider.of<ChatManager>(context, listen: false)
              .selectChatMessage(widget.chatMessages.msgReciept);
        }
      },
      onLongPress: () {
        if (widget.isThisChatSelected) {
          Provider.of<ChatManager>(context, listen: false)
              .unSelectChatMessage(widget.chatMessages.msgReciept);
        } else {
          Provider.of<ChatManager>(context, listen: false)
              .selectChatMessage(widget.chatMessages.msgReciept);
        }
      },
      child: Container(
        margin: EdgeInsets.all(3),
        color: widget.isThisChatSelected
            ? chatSelectedColor()
            : Colors.transparent,
        child: Column(
          crossAxisAlignment: align,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5.0),
              decoration: BoxDecoration(
                color: chatBubbleColor(),
                borderRadius: radius,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5,
                minWidth: 20.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 2),
                  Container(
                    color: chatBubbleColor(),
                    child: Padding(
                      padding: EdgeInsets.all(type == "text" ? 5 : 0),
                      child: type == "text"
                          ? ReadMoreText(
                              widget.chatMessages.message,
                              style: TextStyle(
                                fontSize: 18,
                                color: chatBubbleReplyColor(),
                              ),
                              trimLines: 15,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: t.readmore,
                              trimExpandedText: t.less,
                            )
                          : InkWell(
                              onTap: () {
                                if (widget.isThisChatSelected) {
                                  Provider.of<ChatManager>(context,
                                          listen: false)
                                      .unSelectChatMessage(
                                          widget.chatMessages.msgReciept);
                                } else if (Provider.of<ChatManager>(context,
                                            listen: false)
                                        .selectedChatMessages
                                        .length >
                                    0) {
                                  Provider.of<ChatManager>(context,
                                          listen: false)
                                      .selectChatMessage(
                                          widget.chatMessages.msgReciept);
                                } else
                                  Navigator.pushNamed(
                                      context, PhotoViewer.routeName,
                                      arguments: ScreenArguements(
                                        position: 0,
                                        items: widget.chatMessages,
                                      ));
                              },
                              child: Container(
                                height: 250,
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: widget.chatMessages.attachment != ""
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            widget.chatMessages.attachment,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                            child:
                                                CupertinoActivityIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                child: Icon(
                                          Icons.error,
                                          color: Colors.grey,
                                        )),
                                      )
                                    : Image.file(
                                        File.fromUri(Uri.parse(
                                            widget.chatMessages.uploadFile)),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: isMe
                      ? EdgeInsets.only(
                          right: 10,
                          bottom: 10.0,
                        )
                      : EdgeInsets.only(
                          left: 10,
                          bottom: 10.0,
                        ),
                  child: Text(
                    TimUtil.formatFullDatestamp(widget.chatMessages.date),
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
                isMe
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: widget.chatMessages.seen == 0
                            ? Icon(
                                Icons.done_all,
                                color: Colors.blue,
                                size: 14,
                              )
                            : Icon(
                                Icons.check,
                                size: 14,
                              ),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
