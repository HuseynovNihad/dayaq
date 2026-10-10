import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../families/domain/entities/family_entity.dart';
import 'home_recent_family_card.dart';

class HomeRecentFamiliesSection extends StatelessWidget {
  const HomeRecentFamiliesSection({
    super.key,
    required this.families,
    this.onSeeAllTap,
    this.onFamilyTap,
  });

  final List<FamilyEntity> families;
  final VoidCallback? onSeeAllTap;
  final ValueChanged<FamilyEntity>? onFamilyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Son əlavə edilən ailələr',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            TextButton(
              onPressed: onSeeAllTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hamısına bax',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3954D8),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20.r,
                    color: const Color(0xFF3954D8),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        if (families.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Text(
              'Hələlik ailə qeydiyyatı yoxdur.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < families.length; i++) ...[
                HomeRecentFamilyCard(
                  family: families[i],
                  onTap: onFamilyTap == null
                      ? null
                      : () => onFamilyTap!(families[i]),
                ),
                if (i != families.length - 1) SizedBox(height: 12.h),
              ],
            ],
          ),
      ],
    );
  }
}
