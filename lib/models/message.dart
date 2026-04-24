class Message {
  final String chatId;
  final String contactId;
  final String contactEmail;
  final String imagePath;
  final String username;
  final String currentMessage;
  final DateTime dateTime;
  final int badgeCount;

  const Message({
    required this.chatId,
    required this.contactId,
    required this.contactEmail,
    required this.imagePath,
    required this.username,
    required this.currentMessage,
    required this.dateTime,
    this.badgeCount = 0,
  });
}
