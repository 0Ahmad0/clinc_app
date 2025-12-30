import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AppTextFormFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final Function(String)? onFieldSubmitted;
  final IconData? prefixIcon;
  final int maxLines;
  final bool enabled;
  final bool autofocus;

  const AppTextFormFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.currentFocusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  State<AppTextFormFieldWidget> createState() => _AppTextFormFieldWidgetState();
}

class _AppTextFormFieldWidgetState extends State<AppTextFormFieldWidget> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    final borderRadius = BorderRadius.circular(8.r);

    final baseBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: theme.dividerColor, width: .1),
    );

    return TextFormField(
      autofocus: widget.autofocus,
      controller: widget.controller,
      focusNode: widget.currentFocusNode,
      obscureText: _isObscure,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      maxLines: widget.maxLines,

      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (value) {
        if (widget.textInputAction == TextInputAction.next &&
            widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        } else if (widget.textInputAction == TextInputAction.done &&
            widget.currentFocusNode != null) {
          widget.currentFocusNode!.unfocus();
        }
        widget.onFieldSubmitted?.call(value);
      },
      decoration: InputDecoration(
        errorMaxLines: 2,
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.hintColor,
        ),
        labelStyle: theme.textTheme.bodyMedium,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
              )
            : null,
        suffixIcon: widget.isPassword
            ? _buildVisibilityToggleIcon(theme) // <-- هنا تظهر العين
            : null,
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor ??
            theme.colorScheme.surface.myOpacity(0.5),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: BorderSide(color: theme.primaryColor, width: 1),
        ),
        errorBorder: baseBorder.copyWith(
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
        ),
        focusedErrorBorder: baseBorder.copyWith(
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
        ),
      ),
    );
  }

  Widget _buildVisibilityToggleIcon(ThemeData theme) {
    return IconButton(
      icon: Icon(
        _isObscure ? Iconsax.eye_slash : Iconsax.eye,
        color: theme.iconTheme.color?.myOpacity(0.75),
      ),
      onPressed: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
    );
  }
}
