// استيراد مكتبة الإدخال والإخراج للتعامل مع الملفات والمجلدات
import 'dart:io';

// دالة مساعدة لتحويل اسم الموديل (مثل "user_profile") إلى "UserProfile"
String _toPascalCase(String s) {
  if (s.isEmpty) return '';
  return s.split('_').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }).join('');
}

void main(List<String> args) {
  // 1. التحقق من أن المستخدم أدخل اسم الموديل
  if (args.isEmpty) {
    print("❌ خطأ: الرجاء إدخال اسم الموديل.");
    print("💡 مثال: dart run scripts/create_module.dart my_new_feature");
    return;
  }

  // 2. تعريف المتغيرات
  String moduleName = args[0].toLowerCase(); // "my_new_feature"
  String className = _toPascalCase(moduleName); // "MyNewFeature"
  String basePath = 'lib/modules/$moduleName';

  print('🚀 جاري إنشاء الموديل: $className...');

  // 3. تعريف الهيكل الذي نريده
  List<String> folders = [
    'presentation/screens',
    'presentation/controllers',
    'presentation/bindings',
    'presentation/widgets',
    'domain/repositories',
    'domain/usecases',
    'data/models',
    'data/repositories',
    'data/providers',
  ];

  // 4. إنشاء المجلدات
  try {
    for (var folder in folders) {
      Directory('$basePath/$folder').createSync(recursive: true);
    }
    print('✅ تم إنشاء المجلدات بنجاح.');

    // 5. (اختياري) إنشاء ملفات أساسية (Boilerplate)
    _createFile(
      path: '$basePath/presentation/screens/${moduleName}_screen.dart',
      content: '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/${moduleName}_controller.dart';

class ${className}Screen extends GetView<${className}Controller> {
  const ${className}Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${className}Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '${className}Screen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
''',
    );

    _createFile(
      path: '$basePath/presentation/controllers/${moduleName}_controller.dart',
      content: '''
import 'package:get/get.dart';

class ${className}Controller extends GetxController {
  //TODO: Implement ${className}Controller

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
''',
    );

    _createFile(
      path: '$basePath/presentation/bindings/${moduleName}_binding.dart',
      content: '''
import 'package:get/get.dart';
import '../controllers/${moduleName}_controller.dart';

class ${className}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${className}Controller>(
      () => ${className}Controller(),
    );
  }
}
''',
    );

    print('✅ تم إنشاء الملفات الأساسية (Screen, Controller, Binding).');
    print('🎉 اكتمل إنشاء الموديل: $moduleName');
    print('🔴 تذكير: لا تنسَ إضافة الـ GetPage يدوياً في app/routes/app_pages.dart');

  } catch (e) {
    print("❌ حدث خطأ أثناء إنشاء الهيكل: $e");
  }
}

// دالة مساعدة لإنشاء ملف
void _createFile({required String path, required String content}) {
  File(path).writeAsStringSync(content);
}