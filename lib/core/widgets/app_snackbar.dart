import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';

enum AppSnackBarType { success, error, info }

class AppSnackBar extends StatelessWidget {
  const AppSnackBar({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.onClose,
  });

  final String title;
  final String message;
  final AppSnackBarType type;
  final VoidCallback onClose;

  static void success(
    BuildContext context, {
    required String message,
    String title = 'Uğurlu əməliyyat',
  }) {
    show(
      context,
      title: title,
      message: message,
      type: AppSnackBarType.success,
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    String title = 'Xəta baş verdi',
  }) {
    show(context, title: title, message: message, type: AppSnackBarType.error);
  }

  static void info(
    BuildContext context, {
    required String message,
    String title = 'Məlumat',
  }) {
    show(context, title: title, message: message, type: AppSnackBarType.info);
  }

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required AppSnackBarType type,
    Duration duration = const Duration(seconds: 5),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: duration,
        content: AppSnackBar(
          title: title,
          message: message,
          type: type,
          onClose: () => messenger.hideCurrentSnackBar(),
        ),
      ),
    );
  }

  Color get _accentColor {
    switch (type) {
      case AppSnackBarType.success:
        return AppColors.success;
      case AppSnackBarType.error:
        return AppColors.error;
      case AppSnackBarType.info:
        return AppColors.primary;
    }
  }

  Color get _backgroundColor {
    switch (type) {
      case AppSnackBarType.success:
        return const Color(0xFFF1F8F2);
      case AppSnackBarType.error:
        return const Color(0xFFFFF2F2);
      case AppSnackBarType.info:
        return const Color(0xFFFFF8EB);
    }
  }

  Color get _iconColor {
    switch (type) {
      case AppSnackBarType.success:
        return AppColors.success;
      case AppSnackBarType.error:
        return AppColors.error;
      case AppSnackBarType.info:
        return const Color(0xFF956500);
    }
  }

  IconData get _icon {
    switch (type) {
      case AppSnackBarType.success:
        return Icons.check_circle_outline_rounded;
      case AppSnackBarType.error:
        return Icons.error_outline_rounded;
      case AppSnackBarType.info:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accentColor.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: _accentColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 4, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _accentColor.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_icon, color: _iconColor, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Bildirişi bağla',
                          onPressed: onClose,
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
