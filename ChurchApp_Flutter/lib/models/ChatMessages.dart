class ChatMessages {
  final int id;
  final int chatId;
  final String message, attachment, sender, msgOwner;
  int msgReciept = 0, seen, date;

  String uploadFile = "";
  bool isSaved = true;

  ChatMessages({
    this.id,
    this.chatId,
    this.message,
    this.attachment,
    this.sender,
    this.msgReciept,
    this.msgOwner,
    this.seen,
    this.date,
    this.uploadFile,
    this.isSaved,
  });

  factory ChatMessages.fromJson(Map<String, dynamic> data) {
    int id = int.parse(data['id'].toString());
    int chatId = int.parse(data['chat_id'].toString());
    int msgReciept = int.parse(data['msg_reciept'].toString());
    int seen = int.parse(data['seen'].toString());
    int date = int.parse(data['date'].toString());
    return ChatMessages(
      id: id,
      chatId: chatId,
      message: data['message'],
      attachment: data['attachment'],
      sender: data['sender'],
      msgReciept: msgReciept,
      msgOwner: data['msg_owner'],
      seen: seen,
      date: date,
      isSaved: true,
    );
  }
}
