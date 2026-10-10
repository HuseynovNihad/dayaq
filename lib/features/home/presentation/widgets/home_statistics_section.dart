
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import 'home_stat_card.dart';

class HomeStatisticsSection extends StatelessWidget {
  const HomeStatisticsSection({
    super.key,
    required this.totalFamilies,
    required this.monthlyRegistrations,
  });

  final int totalFamilies;
  final int monthlyRegistrations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cari statistika göstəriciləri',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: 16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HomeStatCard(
                title: 'Ümumi ailələr',
                value: totalFamilies.toString(),
                icon: Icons.family_restroom_rounded,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: HomeStatCard(
                title: 'Bu ay əlavə edilən',
                value: monthlyRegistrations.toString(),
                icon: Icons.calendar_month_rounded,
                iconColor: const Color(0xFF3954D8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
