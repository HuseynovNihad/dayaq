import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 28,
            vertical: isTablet ? 48 : 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isTablet ? 112 : 90,
                height: isTablet ? 112 : 90,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3DC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: isTablet ? 52 : 42,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: isTablet ? 24 : 20),
              Text(
                'Hələ bildiriş yoxdur',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: isTablet ? 22 : null,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Yeni bildirişləriniz olduqda burada görünəcək.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: isTablet ? 16 : null,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
