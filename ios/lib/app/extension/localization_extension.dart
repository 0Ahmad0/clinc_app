import 'package:get/get.dart';

extension LocalizationHelper on String {
  String trNumbers() {
    if (Get.locale?.languageCode != 'ar') return this;

    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = this;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }

    return result.replaceAll('AM', 'ص').replaceAll('PM', 'م');
  }
}
