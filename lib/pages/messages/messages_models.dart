/// Static mock data for the Messages tab.
class Conversation {
  final String name;
  final String lastMessage;
  final int unread;
  final bool sentCheck; // shows a read/sent check before the message
  final int seed; // avatar gradient seed

  const Conversation({
    required this.name,
    required this.lastMessage,
    this.unread = 0,
    this.sentCheck = false,
    this.seed = 0,
  });
}

/// One message in a chat thread. [isMe] = sent by the current user.
class ChatMessage {
  final String text;
  final bool isMe;

  const ChatMessage(this.text, {required this.isMe});
}

class MessagesMockData {
  MessagesMockData._();

  /// Mock thread shown on the chat detail screen.
  static const List<ChatMessage> thread = [
    ChatMessage(
      'Hi Nisha, please make sure to send me the documents. '
      'I need to give it for verifications.',
      isMe: true,
    ),
    ChatMessage('Yes I will send by Monday.', isMe: false),
    ChatMessage('What about my WIFI setup?', isMe: false),
    ChatMessage('Yes, its done!', isMe: true),
  ];

  static const List<Conversation> conversations = [
    Conversation(
      name: 'Nisha Deo',
      lastMessage: 'Yes, its done!',
      unread: 3,
      sentCheck: true,
      seed: 3,
    ),
    Conversation(
      name: 'Christopher K.',
      lastMessage: 'It will be transferred by Sunda..',
      unread: 1,
      seed: 1,
    ),
    Conversation(
      name: 'Natasha V.',
      lastMessage: 'Image',
      seed: 6,
    ),
    Conversation(
      name: 'Mike Johnson',
      lastMessage: 'It\'s fixed. Let me know if you get the issue..',
      seed: 7,
    ),
  ];
}
