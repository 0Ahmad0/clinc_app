import 'package:clinc_app_t1/app/controllers/settings_app_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/app/core/constants/app_constants.dart';
import '/app/routes/app_pages.dart';
import '/app/routes/app_routes.dart';
import 'app/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'generated/codegen_loader.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    ScreenUtil.ensureScreenSize(),
    GetStorage.init(),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  ]);
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(AppConstants.arLang),
        Locale(AppConstants.enLang),
      ],
      path: AppConstants.translationPath,
      assetLoader: const CodegenLoader(),
      fallbackLocale: const Locale(AppConstants.arLang),
      child: const PillWiseApp(),
    ),
  );
}

class PillWiseApp extends StatelessWidget {
  const PillWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsAppController settingsController =
        Get.put(SettingsAppController(), permanent: true);
    return ScreenUtilInit(
      designSize:
          const Size(AppConstants.designWidth, AppConstants.designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: InitialBinding(),
          theme: AppTheme.lightTheme,
          // <--- تطبيق الثيم الأبيض
          darkTheme: AppTheme.darkTheme,
          // <--- تطبيق الثيم الأسود
          themeMode:ThemeMode.light,
          // (أو .light أو .dark)
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          defaultTransition: Transition.leftToRightWithFade,
          debugShowCheckedModeBanner: false,
          getPages: AppPages.routes,
          initialRoute: AppRoutes.initial,
        );
      },
    );
  }
}

/*
Colors
Grayscale
#1C1F1E
#A7A6A5
#CDCFCE
#EFF2F1
#F4F6F5
#FFFFFF
Accent Primary
#66CA98
#F4A3EC
#6295E2
#FF6C52
Accent Secondary
#FFF7DC
#FFDCFB
#E0EAF9
#FFE2DC
 */
