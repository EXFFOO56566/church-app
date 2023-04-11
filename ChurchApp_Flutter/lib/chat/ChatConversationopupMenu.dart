import '../models/Userdata.dart';
import '../providers/ChatManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../i18n/strings.g.dart';

enum MenuIndex { CLEAR, BLOCK }

class MenuList {
  MenuList({
    this.index,
    this.title = '',
  });

  String title;
  MenuIndex index;
}

class ChatConversationopupMenu extends StatelessWidget {
  ChatConversationopupMenu({this.userdata});
  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    int status = Provider.of<ChatManager>(context).selectedChat.isBlocked;

    return PopupMenuButton(
      elevation: 3.2,
      //initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        List<MenuList> choices = [];
        choices.add(
            new MenuList(title: t.clearconversation, index: MenuIndex.CLEAR));
        choices.add(new MenuList(
            title: (status == 1 ? t.block : t.unblock) + " " + userdata.name,
            index: MenuIndex.BLOCK));

        return choices.map((itm) {
          return PopupMenuItem(
            value: itm,
            child: Text(itm.title),
          );
        }).toList();
      },
      //initialValue: 2,
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (value) async {
        MenuList itm = (value as MenuList);
        print(value);
        switch (itm.index) {
          case MenuIndex.CLEAR:
            await showDialog(
              context: context,
              builder: (context) => new CupertinoAlertDialog(
                title: new Text(t.clearconversation),
                content: new Text(t.clearconversationhintone +
                    userdata.name +
                    t.clearconversationhinttwo),
                actions: <Widget>[
                  new TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(t.cancel),
                  ),
                  new TextButton(
                    onPressed: () {
                      Provider.of<ChatManager>(context, listen: false)
                          .clearUserConversation();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text(t.ok),
                  ),
                ],
              ),
            );
            break;
          case MenuIndex.BLOCK:
            Provider.of<ChatManager>(context, listen: false)
                .blockUnblockUserDialog(context);
            break;

          default:
        }
      },
      icon: Icon(
        Icons.more_vert,
        size: 24,
        color: Colors.white,
      ),
    );
  }
}
