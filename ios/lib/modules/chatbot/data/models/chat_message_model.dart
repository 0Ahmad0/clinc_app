

class ChatMessage {
  final String text;
  final bool isSender; // هل أنا المرسل أم البوت؟
  final bool isImage;
  final String? imagePath;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isSender,
    this.isImage = false,
    this.imagePath,
    required this.time,
  });
}

