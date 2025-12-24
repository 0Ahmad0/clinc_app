import 'package:get/get.dart';

class PaymentController extends GetxController {
  var selectedPaymentMethod = 'mada'.obs;

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }
}