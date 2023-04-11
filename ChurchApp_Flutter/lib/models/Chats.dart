import '../models/Userdata.dart';
import 'ChatMessages.dart';

class Chats {
  int id = 0;
  final String email1, email2;
  int unseen = 0;
  int lastMessageTime = 0;
  int lastSeenDate = 0;
  List<ChatMessages> chatMessages = [];
  int isOnline = 1;
  String lastMessage = "";
  final Userdata partner;
  bool isTyping = false;
  int isBlocked = 1;
  int hasMoreContent = 1;

  Chats({
    this.id,
    this.email1,
    this.email2,
    this.unseen,
    this.lastMessageTime,
    this.chatMessages,
    this.isOnline,
    this.lastMessage,
    this.partner,
    this.lastSeenDate,
    this.isBlocked,
    this.hasMoreContent,
  });

  factory Chats.fromJson(Map<String, dynamic> data) {
    int id = int.parse(data['id'].toString());
    int unseen = int.parse(data['unseen'].toString());
    int lastMessageTime = int.parse(data['last_message_time'].toString());
    int isOnline = int.parse(data['isOnline'].toString());
    int _lastSeenDate = int.parse(data['lastSeenDate'].toString());
    int isBlocked = int.parse(data['is_blocked'].toString());
    int hasMoreContent = int.parse(data['have_more_content'].toString());
    return Chats(
      id: id,
      email1: data['email1'],
      email2: data['email2'],
      unseen: unseen,
      lastMessageTime: lastMessageTime,
      chatMessages: getChats(data),
      isOnline: isOnline,
      lastMessage: data['lastMessage'],
      partner: Userdata.fromJsonActivated(data['partner']),
      lastSeenDate: _lastSeenDate,
      isBlocked: isBlocked,
      hasMoreContent: hasMoreContent,
    );
  }

  static List<ChatMessages> getChats(dynamic res) {
    // final res = jsonDecode(responseBody);
    final parsed = res["chats"].cast<Map<String, dynamic>>();
    return parsed
        .map<ChatMessages>((json) => ChatMessages.fromJson(json))
        .toList();
  }
}
