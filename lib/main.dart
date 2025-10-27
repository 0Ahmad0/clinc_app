import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pillwise_app/app/core/constants/app_constants.dart';
import 'package:pillwise_app/app/routes/app_pages.dart';
import 'package:pillwise_app/app/routes/app_routes.dart';

import 'app/core/theme/app_theme.dart';
import 'generated/codegen_loader.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    ScreenUtil.ensureScreenSize(),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  ]);
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      fallbackLocale: const Locale('ar'),
      child: const PillWiseApp(),
    ),
  );
}

class PillWiseApp extends StatelessWidget {
  const PillWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(AppConstants.designWidth, AppConstants.designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          theme: AppTheme.lightTheme,
          // <--- تطبيق الثيم الأبيض
          darkTheme: AppTheme.darkTheme,
          // <--- تطبيق الثيم الأسود
          themeMode: ThemeMode.light,
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
