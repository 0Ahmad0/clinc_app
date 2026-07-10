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

  String get role => isSender ? 'user' : 'assistant';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final role = json['role']?.toString().toLowerCase();
    final senderFlag = json['is_sender'] == true || role == 'user';
    return ChatMessage(
      text: (json['text'] ?? json['message'] ?? '')?.toString() ?? '',
      isSender: senderFlag,
      isImage: json['is_image'] == true,
      imagePath: json['image_path']?.toString(),
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'role': role,
    'is_sender': isSender,
    'is_image': isImage,
    'image_path': imagePath,
    'time': time.toIso8601String(),
  };
}
