import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AppRatingWidget extends StatefulWidget {
  final String title;
  final String hintText;
  final String buttonText;
  final double initialRating;
  final Function(double rating, String comment) onSubmit;

  const AppRatingWidget({
    super.key,
    this.title = "قيم تجربتك",
    this.hintText = "اكتب رأيك بصراحة...",
    this.buttonText = "إرسال التقييم",
    this.initialRating = 0.0,
    required this.onSubmit,
  });

  @override
  State<AppRatingWidget> createState() => _AppRatingWidgetState();
}

class _AppRatingWidgetState extends State<AppRatingWidget> {
  late final TextEditingController _commentController;
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _currentRating = widget.initialRating;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_currentRating == 0) {
      return;
    }
    widget.onSubmit(_currentRating, _commentController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          16.verticalSpace,
          RatingBar.builder(
            initialRating: widget.initialRating,
            minRating: 1,
            itemSize: 34.sp,
            allowHalfRating: true,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
            itemBuilder: (_, __) =>
                const Icon(Iconsax.star1, color: Colors.amber),
            onRatingUpdate: (rating) => setState(() => _currentRating = rating),
          ),
          20.verticalSpace,
          AppTextFormFieldWidget(
            controller: _commentController,
            hintText: widget.hintText,
            maxLines: 3,
          ),
          20.verticalSpace,
          AppButtonWidget(
            backgroundColor: _currentRating == 0
                ? Colors.grey
                : Theme.of(context).primaryColor,
            onPressed: _currentRating == 0 ? null : _handleSubmit,
            text: widget.buttonText,
          ),
        ],
      ),
    );
  }
}
