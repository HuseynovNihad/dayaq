import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.backgroundColor = const Color(0xFFF5F3F3),
    this.iconColor = const Color(0xFF946300),
  });

  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isTablet ? 145 : 140),
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistika ikonu
          Container(
            width: isTablet ? 46 : 34,
            height: isTablet ? 46 : 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
            ),
            child: Icon(icon, size: isTablet ? 26 : 20, color: iconColor),
          ),

          SizedBox(height: isTablet ? 12 : 10),

          // Statistik rəqəm
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: isTablet ? 32 : 26,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: isTablet ? 6 : 4),

          // Statistika başlığı
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: isTablet ? 16 : 13,
              fontWeight: FontWeight.w500,
              height: 1.3,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
