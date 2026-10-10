import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      width: double.infinity,
      height: 150.h,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistika ikonu
          Container(
            width: 36.r,
            height: 36.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 21.r, color: iconColor),
          ),

          SizedBox(height: 16.h),

          // Statistik rəqəm
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 4.h),

          // Statistika başlığı
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
