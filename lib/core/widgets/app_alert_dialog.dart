import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';

/// Dayaq tətbiqində xəta və təsdiq mesajları üçün ortaq dialoq.
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog._({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.primaryLabel,
    this.secondaryLabel,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  static Future<void> showError({
    required BuildContext context,
    required String message,
    String title = 'Əməliyyat tamamlanmadı',
    VoidCallback? onRetry,
  }) async {
    final retry = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.32),
      builder: (dialogContext) => AppAlertDialog._(
        title: title,
        message: message,
        icon: Icons.error_outline_rounded,
        iconColor: const Color(0xFFB84D46),
        iconBackground: const Color(0xFFFCEDEB),
        primaryLabel: onRetry == null ? 'Bağla' : 'Yenidən cəhd et',
        secondaryLabel: onRetry == null ? null : 'Bağla',
        onPrimaryPressed: () =>
            Navigator.of(dialogContext).pop(onRetry != null),
        onSecondaryPressed: () => Navigator.of(dialogContext).pop(false),
      ),
    );

    if (retry == true && context.mounted) onRetry?.call();
  }

  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Təsdiqlə',
    String cancelLabel = 'Geri qayıt',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.32),
      builder: (dialogContext) => AppAlertDialog._(
        title: title,
        message: message,
        icon: isDestructive
            ? Icons.help_outline_rounded
            : Icons.info_outline_rounded,
        iconColor: isDestructive ? const Color(0xFFB36B30) : AppColors.primary,
        iconBackground: isDestructive
            ? const Color(0xFFFFF2E4)
            : const Color(0xFFFFF3D9),
        primaryLabel: confirmLabel,
        secondaryLabel: cancelLabel,
        onPrimaryPressed: () => Navigator.of(dialogContext).pop(true),
        onSecondaryPressed: () => Navigator.of(dialogContext).pop(false),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 390.w),
        child: Container(
          padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: const Color(0xFFF0EDE8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 68.r,
                width: 68.r,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 32.r),
              ),
              SizedBox(height: 18.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 9.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                height: 48.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPrimaryPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                  ),
                  child: Text(
                    primaryLabel,
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (secondaryLabel != null) ...[
                SizedBox(height: 8.h),
                SizedBox(
                  height: 44.h,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onSecondaryPressed,
                    child: Text(
                      secondaryLabel!,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
