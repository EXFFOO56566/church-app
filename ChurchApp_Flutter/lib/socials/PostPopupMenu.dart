import 'package:flutter/material.dart';
import '../models/UserPosts.dart';
import '../i18n/strings.g.dart';

enum MenuIndex { EDIT, DELETE }

class MenuList {
  MenuList({
    this.index,
    this.title = '',
  });

  String title;
  MenuIndex index;
}

class PostPopupMenu extends StatelessWidget {
  PostPopupMenu(this.userPosts, this.editPost, this.deletePost);
  final UserPosts userPosts;
  final Function editPost;
  final Function deletePost;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 3.2,
      //initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        List<MenuList> choices = [];
        choices.add(new MenuList(title: t.edit, index: MenuIndex.EDIT));
        choices.add(new MenuList(title: t.delete, index: MenuIndex.DELETE));
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
      onSelected: (value) {
        MenuList itm = (value as MenuList);
        print(value);
        switch (itm.index) {
          case MenuIndex.EDIT:
            editPost();
            break;
          case MenuIndex.DELETE:
            deletePost();
            break;

          default:
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey[500],
      ),
    );
  }
}
