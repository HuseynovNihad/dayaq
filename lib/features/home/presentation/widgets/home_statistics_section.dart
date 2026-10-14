import 'package:flutter/material.dart';

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
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cari statistika göstəriciləri',
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: isTablet ? 22 : null,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: isTablet ? 20 : 16),

        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: HomeStatCard(
                  title: 'Ümumi ailələr',
                  value: totalFamilies.toString(),
                  icon: Icons.family_restroom_rounded,
                ),
              ),

              SizedBox(width: isTablet ? 16 : 12),

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
        ),
      ],
    );
  }
}
