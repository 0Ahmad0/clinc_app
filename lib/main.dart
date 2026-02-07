import 'package:clinc_app_t1/app/controllers/settings_app_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/constants/app_constants.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'generated/codegen_loader.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    ScreenUtil.ensureScreenSize(),
    GetStorage.init(),
  ]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Get.put(SettingsAppController(), permanent: true);
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(AppConstants.arLang),
        Locale(AppConstants.enLang),
      ],
      startLocale: Locale(AppConstants.arLang),
      fallbackLocale: const Locale(AppConstants.arLang),
      path: AppConstants.translationPath,
      assetLoader: const CodegenLoader(),
      child: const PillWiseApp(),
    ),
  );
}

class PillWiseApp extends StatelessWidget {
  const PillWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        AppConstants.designWidth,
        AppConstants.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<SettingsAppController>(
          id: 'app_localization',
          builder: (settingsController) {
            return GetMaterialApp(
              initialBinding: InitialBinding(),
              theme: AppTheme.lightTheme(context.locale.languageCode),
              darkTheme: AppTheme.darkTheme(context.locale.languageCode),
              themeMode: settingsController.themeMode,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: [
                ...context.localizationDelegates,
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
              defaultTransition: Transition.leftToRightWithFade,
              debugShowCheckedModeBanner: false,
              getPages: AppPages.routes,
              initialRoute: AppRoutes.initial,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            );
          },
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
