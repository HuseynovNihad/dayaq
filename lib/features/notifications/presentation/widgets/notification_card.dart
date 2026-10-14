import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 22 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 18),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: isTablet ? 14 : 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isTablet ? 58 : 48,
            height: isTablet ? 58 : 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2D6),
              borderRadius: BorderRadius.circular(isTablet ? 16 : 14),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: const Color(0xFFE49A00),
              size: isTablet ? 30 : 25,
            ),
          ),
          SizedBox(width: isTablet ? 18 : 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: isTablet ? 19 : null,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (notification.description.trim().isNotEmpty) ...[
                  SizedBox(height: isTablet ? 10 : 7),
                  Text(
                    notification.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: isTablet ? 16 : null,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
