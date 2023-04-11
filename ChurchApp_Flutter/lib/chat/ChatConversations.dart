import 'package:churchapp_flutter/utils/my_colors.dart';

import '../utils/TimUtil.dart';
import '../screens/EmptyListScreen.dart';
import '../screens/NoitemScreen.dart';
import 'package:flutter/cupertino.dart';
import '../providers/events.dart';
import '../providers/ChatManager.dart';
import 'package:flutter/material.dart';
import 'components/chat_bubble.dart';
import 'package:provider/provider.dart';
import '../models/Chats.dart';
import '../models/UserEvents.dart';
import '../models/ChatMessages.dart';
import 'dart:math';
import '../i18n/strings.g.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'ChatConversationopupMenu.dart';

class ChatConversations extends StatefulWidget {
  static const routeName = "/ChatConversations";
  @override
  _ChatConversationsState createState() => _ChatConversationsState();
}

class _ChatConversationsState extends State<ChatConversations> {
  ChatManager chatManager;
  Chats selectedChat;

  @override
  Widget build(BuildContext context) {
    chatManager = Provider.of<ChatManager>(context);
    selectedChat = chatManager.selectedChat;

    return WillPopScope(
      onWillPop: () async {
        if (chatManager.selectedChatMessages.length > 0) {
          chatManager.resetSelectedChatMessages();
          return false;
        } else {
          print("close chat messages here");
          eventBus.fire(AppEvents.ONCHATCONVERSATIONCLOSED);
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: () {
              print("close chat messages here");
              eventBus.fire(AppEvents.ONCHATCONVERSATIONCLOSED);
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title: chatManager.selectedChatMessages.length > 0
              ? Text(
                  chatManager.selectedChatMessages.length.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                )
              : InkWell(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, right: 10.0),
                        child: CircleAvatar(
                          foregroundColor: Colors.transparent,
                          backgroundImage:
                              NetworkImage(selectedChat.partner.avatar),
                          //radius: 30.0,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              selectedChat.partner.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            selectedChat.isTyping
                                ? Text(
                                    t.typing,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                  )
                                : Text(
                                    selectedChat.isOnline == 0
                                        ? t.online
                                        : (selectedChat.lastSeenDate == 0
                                            ? t.offline
                                            : t.lastseen +
                                                " " +
                                                TimUtil.timeAgoSinceDate(
                                                    selectedChat.lastSeenDate)),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
          actions: <Widget>[
            chatManager.selectedChatMessages.length > 0
                ? IconButton(
                    icon: Icon(
                      Icons.delete_sweep,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => new CupertinoAlertDialog(
                          title: new Text(t.deleteselected),
                          content: new Text(t.deleteselectedhint),
                          actions: <Widget>[
                            new TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: new Text(t.cancel),
                            ),
                            new TextButton(
                              onPressed: () {
                                Provider.of<ChatManager>(context, listen: false)
                                    .deleteSelectedChatMessagesOnline();
                                Navigator.of(context).pop(true);
                              },
                              child: new Text(t.ok),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(),
            chatManager.selectedChatMessages.length > 0
                ? IconButton(
                    icon: Icon(
                      Icons.share,
                    ),
                    onPressed: () {
                      chatManager.shareHightlightedMessages();
                    },
                  )
                : Container(),
            chatManager.selectedChatMessages.length > 0
                ? IconButton(
                    icon: Icon(
                      Icons.content_copy,
                    ),
                    onPressed: () {
                      chatManager.copyHighlightedMessages(context);
                    },
                  )
                : Container(),
            chatManager.selectedChatMessages.length == 0
                ? ChatConversationopupMenu(
                    userdata: chatManager.selectedChat.partner,
                  )
                : Container(),
          ],
        ),
        body: GetPartnerChatBody(
            selectedChat: selectedChat, chatManager: chatManager),
      ),
    );
  }
}

class GetPartnerChatBody extends StatefulWidget {
  const GetPartnerChatBody({
    @required this.selectedChat,
    @required this.chatManager,
  });

  final Chats selectedChat;
  final ChatManager chatManager;

  @override
  _GetPartnerChatBodyState createState() => _GetPartnerChatBodyState();
}

class _GetPartnerChatBodyState extends State<GetPartnerChatBody> {
  TextEditingController _textEditingController;
  bool shouldSendTypeNotification = true;
  ScrollController _controller;

  _scrollListener() {
    //print(
    //  "minScrollExtent = " + _controller.position.maxScrollExtent.toString());
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      Provider.of<ChatManager>(context, listen: false).loadMoreChats();
    }
  }

  @override
  void initState() {
    shouldSendTypeNotification = true;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _textEditingController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chatManager.fetchingSelectedChatDetails) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    } else if (widget.chatManager.partnerChatFetchError) {
      return NoitemScreen(
        title: "",
        message: t.unabletofetchconversation + widget.selectedChat.partner.name,
        onClick: () {
          eventBus.fire(StartPartnerChatEvent(widget.selectedChat.partner));
        },
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          (widget.chatManager.isLoadingMoreChats ||
                  widget.chatManager.isErrorLoadingMoreChats)
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 50,
                    ),
                    child: Center(
                      child: widget.chatManager.isLoadingMoreChats
                          ? CupertinoActivityIndicator()
                          : (widget.chatManager.isErrorLoadingMoreChats
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                  ),
                                  child: Text(t.loadmoreconversation),
                                  onPressed: () {
                                    Provider.of<ChatManager>(context,
                                            listen: false)
                                        .loadMoreChats();
                                  })
                              : Container()),
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: widget.selectedChat.chatMessages.length == 0
                ? EmptyListScreen(
                    message: t.sendyourfirstmessage +
                        widget.selectedChat.partner.name)
                : ListView.builder(
                    controller: _controller,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    itemCount: widget.selectedChat.chatMessages.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatBubble(
                        key: UniqueKey(),
                        isThisChatSelected: widget.chatManager
                            .isChatMessageSelected(widget
                                .selectedChat.chatMessages[index].msgReciept),
                        recipient: widget.selectedChat.partner.email,
                        chatMessages: widget.selectedChat.chatMessages[index],
                        userdata: widget.chatManager.userdata,
                      );
                    },
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomAppBar(
              elevation: 10,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: widget.selectedChat.isBlocked == 0 ? 60 : 100,
                ),
                child: widget.selectedChat.isBlocked == 0
                    ? Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: MyColors.primary,
                            ),
                            child: Text(
                                t.unblock + widget.selectedChat.partner.name),
                            onPressed: () {
                              Provider.of<ChatManager>(context, listen: false)
                                  .blockUnblockUserDialog(context);
                            }))
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.image,
                              //color: Theme.of(context).accentColor,
                            ),
                            onPressed: () async {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowCompression: true,
                                allowMultiple: false,
                                withData: false,
                                allowedExtensions: [
                                  'png',
                                  'PNG',
                                  'JPEG',
                                  'JPG',
                                  'jpg',
                                  'jpeg',
                                  'gif'
                                ],
                              );
                              if (mounted) {
                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  final filePath =
                                      await FlutterAbsolutePath.getAbsolutePath(
                                          file.path);
                                  //Toast.show(filePath, context);
                                  if (file.size > (1024 * 1)) {
                                    Toast.show(
                                        t.maximumuploadsizehint, context);
                                    return;
                                  }

                                  int date =
                                      (DateTime.now().millisecondsSinceEpoch ~/
                                          1000);
                                  eventBus
                                      .fire(OnNewChatConversation(ChatMessages(
                                    id: 0,
                                    chatId: 0,
                                    message: "",
                                    attachment: "",
                                    sender: widget.chatManager.userdata.email,
                                    msgReciept:
                                        new Random().nextInt(10000) + date,
                                    msgOwner: widget.chatManager.userdata.email,
                                    seen: 1,
                                    date: date,
                                    uploadFile: filePath,
                                    isSaved: false,
                                  )));
                                }
                              }
                            },
                          ),
                          Flexible(
                            child: TextField(
                              controller: _textEditingController,
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                              //maxLength: 500,
                              onChanged: (value) {
                                if (value.length > 1 &&
                                    shouldSendTypeNotification) {
                                  Provider.of<ChatManager>(context,
                                          listen: false)
                                      .notifyUserTyping();
                                  setState(() {
                                    shouldSendTypeNotification = false;
                                  });
                                  Timer(Duration(seconds: 15), () {
                                    if (mounted) {
                                      setState(() {
                                        shouldSendTypeNotification = true;
                                      });
                                    }
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: t.writeyourmessage,
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              if (_textEditingController.text.trim() == "")
                                return;
                              int date =
                                  (DateTime.now().millisecondsSinceEpoch ~/
                                      1000);
                              eventBus.fire(OnNewChatConversation(ChatMessages(
                                id: 0,
                                chatId: 0,
                                message: _textEditingController.text.trim(),
                                attachment: "",
                                sender: widget.chatManager.userdata.email,
                                msgReciept: new Random().nextInt(10000) + date,
                                msgOwner: widget.chatManager.userdata.email,
                                seen: 1,
                                date: date,
                                uploadFile: "",
                                isSaved: false,
                              )));
                              _textEditingController.text = "";
                            },
                          )
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
