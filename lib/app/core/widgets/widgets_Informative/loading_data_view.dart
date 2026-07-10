import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class LoadingDataView extends StatelessWidget {
  final bool isShowContainer;

  const LoadingDataView({super.key, this.isShowContainer = false});
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        // width: ScreenUtil.defaultSize.width * 0.2,
        //   height: ScreenUtil.defaultSize.width * 0.2,
        decoration: BoxDecoration(
            color: isShowContainer ? AppColors.white : null,
           /// borderRadius: BorderRadius.circular(8.sp //AppSize.s8
            ///     )
        ),
        child:
        const CircularProgressIndicator(
          color: AppColors.primary,
        )
        // LoadingAnimationWidget.discreteCircle(
        //     secondRingColor: AppColors.secondary,
        //     thirdRingColor: AppColors.lightGray,
        //     color: AppColors.primary,
        //     size: ScreenUtil.defaultSize.width * 0.1)

    );
  }
}

class LoadingDataBaseView extends StatelessWidget {
  final bool isShowContainer;
  const LoadingDataBaseView({super.key, this.isShowContainer = false});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          // width: ScreenUtil.defaultSize.width * 0.2,
          //   height: ScreenUtil.defaultSize.width * 0.2,
          decoration: BoxDecoration(
              color: isShowContainer ? AppColors.white : null,
              borderRadius: BorderRadius.circular(8.sp //AppSize.s8
                  )),
          child:
          const CircularProgressIndicator(
            color: AppColors.primary,

          )
          // LoadingAnimationWidget.discreteCircle(
          //     secondRingColor: ColorManager.primaryLight,
          //     thirdRingColor: ColorManager.grey,
          //     color: ColorManager.primary,
          //     size: ScreenUtil.defaultSize.width * 0.1)

      ),
    );
  }
}

// class LoadingRequestView extends StatelessWidget {
//   LoadingRequestView({required this.size, this.padding = 0});
//   final double size;
//   double padding;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: LoadingAnimationWidget.flickr(
//           leftDotColor: AppColors.secondary,
//           rightDotColor: AppColors.primary,
//           size: size),
//     );
//   }
// }
