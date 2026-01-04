import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/models/card_utils.dart';

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final CardType cardType;
  final bool isPreview;
  final VoidCallback? onDelete;

  const CreditCardWidget({
    super.key,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.cardType,
    this.isPreview = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = CardUtils.getCardColor(cardType);
    final logoAsset = CardUtils.getCardIcon(cardType);

    return Container(
      height: 200.h,
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cardColor.myOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor.myOpacity(0.8), cardColor],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvgWidget(
                assetsUrl: AppAssets.cardChipIcon,
                height: 30.h,
                width: 40.w,
              ),
              Row(
                children: [
                  if (logoAsset.isNotEmpty)
                    AppSvgWidget(
                      assetsUrl: logoAsset,
                      height: 30.h,
                      width: 50.w,
                    ),
                  if (!isPreview && onDelete != null) ...[
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: onDelete,
                      child: Icon(
                        Iconsax.trash,
                        color: Colors.white70,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          // Number
          Text(
            cardNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
          ),

          // Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCardInfo(
                tr(LocaleKeys.payment_settings_card_holder),
                holderName,
              ),
              _buildCardInfo(
                tr(LocaleKeys.payment_settings_expiry),
                expiryDate,
                alignEnd: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfo(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10.sp,
            letterSpacing: 1,
          ),
        ),
        4.verticalSpace,
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}









