import 'package:flutter/material.dart';
import 'UserProfileScreen.dart';
import '../models/ScreenArguements.dart';
import '../models/Userdata.dart';
import '../providers/events.dart';
import '../models/UserEvents.dart';
import '../chat/ChatConversations.dart';

Widget getUserName(BuildContext context, Userdata userdata,
    {bool isClickable = true}) {
  return InkWell(
    onTap: () {
      if (!isClickable) {
        eventBus.fire(StartPartnerChatEvent(userdata));
        Navigator.pushReplacementNamed(
          context,
          ChatConversations.routeName,
        );
      } else
        Navigator.pushNamed(
          context,
          UserProfileScreen.routeName,
          arguments: ScreenArguements(items: userdata),
        );
    },
    child: Text(
      userdata.name,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: 'WorkSans',
      ),
    ),
  );
}
