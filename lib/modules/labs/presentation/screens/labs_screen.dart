import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/labs_controller.dart';

class LabsScreen extends GetView<LabsController> {
  const LabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LabsScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LabsScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
