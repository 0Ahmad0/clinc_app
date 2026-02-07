import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/appointments/presentation/screens/appointments_screen.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/screens/doctors_screen.dart';
import 'package:clinc_app_t1/modules/home/presentation/screens/home_screen.dart';
import 'package:clinc_app_t1/modules/settings/presentation/screens/settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/navbar_controller.dart';
import '../widgets/navbar_item_widget.dart';

class NavbarScreen extends GetView<NavbarController> {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final inactiveColor = Theme.of(context).disabledColor;
    DateTime? currentBackPressTime;
    Future<bool> _onWillPop() async {
      DateTime now = DateTime.now();

      // إذا كان أول مرة يضغط أو مر أكثر من ثانيتين
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;

        // رسالة تأكيد
        Get.snackbar(
          "اضغط مرة أخرى للخروج",
          "اضغط زر الرجوع مرة أخرى للخروج من التطبيق",
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16.w),
          borderRadius: 12.r,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );

        return false; // لا تخرج
      }
      return await _showExitDialog(context);
    }

    return PopScope(
      canPop: false, // مهم! تعطيل الـ pop الافتراضي
      onPopInvokedWithResult: (bool didPop, _) async {
        if (didPop) return;

        final result = await _showExitDialog(context);
        if (result) {
          // إذا وافق على الخروج، نسمح بالـ pop
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            // إذا ما في screens للرجوع، نخرج من التطبيق
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // لمنع الكيبورد من رفع الناف بار

        // الزر العائم (FAB)
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => Get.toNamed(AppRoutes.search),
          shape: const StarBorder.polygon(pointRounding: .8, sides: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.add_square, size: 26.sp),
              6.verticalSpace,
              Text(
                tr(LocaleKeys.navbar_book_now), // <--- هنا الترجمة
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 9.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,

        // الصفحات
        body: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeScreen(),
              DoctorsScreen(),
              AppointmentsScreen(),
              SettingsScreen(),
            ],
          ),
        ),

        // الشريط السفلي
        bottomNavigationBar: Obx(
          () => AnimatedBottomNavigationBar.builder(
            itemCount: controller.navItems.length,
            tabBuilder: (index, isActive) {
              final navItem = controller.navItems[index];
              final String iconPath = isActive
                  ? navItem.filledIconPath
                  : navItem.outlineIconPath;

              return NavbarItemWidget(
                isActive: isActive,
                iconPath: iconPath,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                navItem: navItem,
              );
            },
            gapWidth: Get.width / 3.5,
            // مسافة للزر العائم
            gapLocation: GapLocation.center,
            height: 60.h,
            // ارتفاع مناسب
            notchSmoothness: NotchSmoothness.softEdge,
            activeIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            backgroundColor: Theme.of(context).colorScheme.surface,
            splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            scaleFactor: 0.5, // تأثير الحركة عند الضغط
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black54,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Column(
                children: [
                  Icon(
                    Icons.exit_to_app_rounded,
                    size: 50.sp,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "هل أنت متأكد من الخروج؟",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: Text(
                "سيتم إغلاق التطبيق بالكامل. تأكد من حفظ جميع بياناتك قبل الخروج.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                // زر الإلغاء
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    "إلغاء",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // زر الخروج
                ElevatedButton(
                  onPressed: () {
                    // إغلاق جميع الـ Screens والخروج
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "خروج",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceBetween,
              contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
              titlePadding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
            );
          },
        ) ??
        false;
  }
}
