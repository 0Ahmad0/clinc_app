import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotScreen extends GetView<ChatbotController> {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatbotScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ChatbotScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
