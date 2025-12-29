import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/insurance_controller.dart';

class InsuranceScreen extends GetView<InsuranceController> {
  const InsuranceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InsuranceScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'InsuranceScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
