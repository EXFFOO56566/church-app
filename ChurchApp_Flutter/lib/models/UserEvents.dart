import 'Userdata.dart';
import 'ChatMessages.dart';

class UserLoggedInEvent {
  Userdata user;
  UserLoggedInEvent(this.user);
}

class StartPartnerChatEvent {
  Userdata user;
  StartPartnerChatEvent(this.user);
}

class OnNewChatConversation {
  ChatMessages chatMessages;
  OnNewChatConversation(this.chatMessages);
}

class OnReceiveChatConversation {
  bool notify;
  Userdata sender;
  String message;
  Map<String, dynamic> items;
  ChatMessages chatMessages;
  OnReceiveChatConversation(
      this.chatMessages, this.sender, this.message, this.items, this.notify);
}

class OnAppStateChanged {
  String state;
  OnAppStateChanged(this.state);
}

class OnChatOpen {
  bool isOpen;
  OnChatOpen(this.isOpen);
}

class OnUserReadConversation {
  String partner;
  OnUserReadConversation(this.partner);
}

class OnUserTyping {
  String partner;
  OnUserTyping(this.partner);
}

class OnUserOnlineStatus {
  String partner;
  int status;
  int lastSeen;
  OnUserOnlineStatus(this.partner, this.status, this.lastSeen);
}

class OnAppOffline {
  Map<String, dynamic> items;
  OnAppOffline(this.items);
}
