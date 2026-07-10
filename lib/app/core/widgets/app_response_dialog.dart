import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

class ResponseDialogAction {
  const ResponseDialogAction({
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.isLoading = false,
    this.closeOnPressed = true,
    this.enabled = true,
  });

  final String text;
  final FutureOr<void> Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool isLoading;
  final bool closeOnPressed;
  final bool enabled;
}

class AppResponseDialog extends StatelessWidget {
  const AppResponseDialog({
    super.key,
    required this.assetPath,
    required this.accentColor,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.actionsBuilder,
    this.primaryAction,
    this.secondaryAction,
    this.showCloseButton = true,
    this.isLoading = false,
    this.backgroundColor,
    this.titleColor,
    this.messageColor,
  });

  final String assetPath;
  final Color accentColor;
  final String? title;
  final String? message;
  final Widget? content;
  final List<ResponseDialogAction>? actions;
  final WidgetBuilder? actionsBuilder;
  final ResponseDialogAction? primaryAction;
  final ResponseDialogAction? secondaryAction;
  final bool showCloseButton;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? messageColor;

  @override
  Widget build(BuildContext context) {
    final dialogActions = actions ?? _defaultActions();
    final hasActions = actionsBuilder != null || dialogActions.isNotEmpty;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth =
              constraints.maxWidth < 430 ? constraints.maxWidth : 430.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: constraints.maxHeight,
              ),
              child: Material(
                color: backgroundColor ?? AppColors.white,
                borderRadius: BorderRadius.circular(28.r),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _ResponseDialogIcon(
                              assetPath: assetPath,
                              accentColor: accentColor,
                            ),
                            if (title != null && title!.trim().isNotEmpty) ...[
                              22.verticalSpace,
                              Text(
                                title!,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  color: titleColor ?? const Color(0xFF111827),
                                  fontSize: 22.sp,
                                  height: 1.2,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ],
                            if (message != null &&
                                message!.trim().isNotEmpty) ...[
                              12.verticalSpace,
                              Text(
                                message!,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  color:
                                      messageColor ?? const Color(0xFF6B7280),
                                  fontSize: 14.sp,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ],
                            if (content != null) ...[
                              18.verticalSpace,
                              content!,
                            ],
                            if (hasActions) ...[
                              26.verticalSpace,
                              if (actionsBuilder != null)
                                actionsBuilder!(context)
                              else
                                ResponseDialogActions(
                                  actions: dialogActions,
                                  accentColor: accentColor,
                                  isLoading: isLoading,
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (showCloseButton)
                      PositionedDirectional(
                        top: 12.h,
                        end: 12.w,
                        child: _ResponseDialogCloseButton(
                          isLoading: isLoading,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<ResponseDialogAction> _defaultActions() {
    return [
      if (secondaryAction != null)
        ResponseDialogAction(
          text: secondaryAction!.text,
          onPressed: secondaryAction!.onPressed,
          backgroundColor:
              secondaryAction!.backgroundColor ?? Colors.transparent,
          foregroundColor: secondaryAction!.foregroundColor ?? accentColor,
          borderColor: secondaryAction!.borderColor ?? accentColor,
          isLoading: secondaryAction!.isLoading,
          closeOnPressed: secondaryAction!.closeOnPressed,
          enabled: secondaryAction!.enabled,
        ),
      if (primaryAction != null)
        ResponseDialogAction(
          text: primaryAction!.text,
          onPressed: primaryAction!.onPressed,
          backgroundColor: primaryAction!.backgroundColor ?? accentColor,
          foregroundColor: primaryAction!.foregroundColor ?? AppColors.white,
          borderColor: primaryAction!.borderColor,
          isLoading: primaryAction!.isLoading,
          closeOnPressed: primaryAction!.closeOnPressed,
          enabled: primaryAction!.enabled,
        ),
    ];
  }
}

class _ResponseDialogIcon extends StatelessWidget {
  const _ResponseDialogIcon({
    required this.assetPath,
    required this.accentColor,
  });

  final String assetPath;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 90.w,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(.10),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        assetPath,
        width: 56.w,
        height: 56.w,
        fit: BoxFit.contain,
      ),
    );
  }
}

class ResponseDialogActions extends StatefulWidget {
  const ResponseDialogActions({
    super.key,
    required this.actions,
    required this.accentColor,
    required this.isLoading,
  });

  final List<ResponseDialogAction> actions;
  final Color accentColor;
  final bool isLoading;

  @override
  State<ResponseDialogActions> createState() => _ResponseDialogActionsState();
}

class _ResponseDialogActionsState extends State<ResponseDialogActions> {
  var _isActionRunning = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useVerticalLayout =
            widget.actions.length > 2 || constraints.maxWidth < 320;
        final children = widget.actions
            .map(
              (action) => _ResponseDialogActionButton(
                action: action,
                accentColor: widget.accentColor,
                disabled: widget.isLoading || _isActionRunning,
                onRunningChanged: (value) {
                  if (!mounted) return;
                  setState(() => _isActionRunning = value);
                },
              ),
            )
            .toList();

        if (useVerticalLayout) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) 10.verticalSpace,
                children[i],
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) 12.horizontalSpace,
              Expanded(child: children[i]),
            ],
          ],
        );
      },
    );
  }
}

class _ResponseDialogActionButton extends StatefulWidget {
  const _ResponseDialogActionButton({
    required this.action,
    required this.accentColor,
    required this.disabled,
    required this.onRunningChanged,
  });

  final ResponseDialogAction action;
  final Color accentColor;
  final bool disabled;
  final ValueChanged<bool> onRunningChanged;

  @override
  State<_ResponseDialogActionButton> createState() =>
      _ResponseDialogActionButtonState();
}

class _ResponseDialogActionButtonState
    extends State<_ResponseDialogActionButton> {
  var _isRunning = false;

  @override
  Widget build(BuildContext context) {
    final isOutlined =
        widget.action.backgroundColor == null &&
        widget.action.borderColor != null;
    final backgroundColor = widget.action.backgroundColor ??
        (isOutlined ? Colors.transparent : widget.accentColor);
    final foregroundColor = widget.action.foregroundColor ??
        (isOutlined ? widget.accentColor : AppColors.white);
    final borderColor = widget.action.borderColor ?? Colors.transparent;
    final isLoading = widget.action.isLoading || _isRunning;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: TextButton(
        onPressed: widget.disabled || !widget.action.enabled || isLoading
            ? null
            : () => _handlePressed(context),
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withOpacity(.70),
          disabledForegroundColor: foregroundColor.withOpacity(.70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: BorderSide(color: borderColor, width: 1.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4.w,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Text(
                widget.action.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Manrope',
                ),
              ),
      ),
    );
  }

  Future<void> _handlePressed(BuildContext context) async {
    if (widget.action.closeOnPressed) {
      Navigator.of(context, rootNavigator: true).pop();
      widget.action.onPressed?.call();
      return;
    }

    widget.onRunningChanged(true);
    setState(() => _isRunning = true);

    try {
      await widget.action.onPressed?.call();
    } finally {
      if (mounted) {
        widget.onRunningChanged(false);
        setState(() => _isRunning = false);
      }
    }
  }
}

class _ResponseDialogCloseButton extends StatelessWidget {
  const _ResponseDialogCloseButton({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading
          ? null
          : () {
              Navigator.of(context, rootNavigator: true).pop();
            },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.close_rounded,
          size: 18.w,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
