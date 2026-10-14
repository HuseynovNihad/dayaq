import 'package:flutter/material.dart';

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
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Son əlavə edilən ailələr',
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: isTablet ? 22 : null,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            SizedBox(width: isTablet ? 12 : 8),

            TextButton(
              onPressed: onSeeAllTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 8 : 0,
                  vertical: isTablet ? 8 : 0,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hamısına bax',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontSize: isTablet ? 15 : null,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3954D8),
                    ),
                  ),

                  SizedBox(width: isTablet ? 4 : 0),

                  Icon(
                    Icons.chevron_right_rounded,
                    size: isTablet ? 24 : 20,
                    color: const Color(0xFF3954D8),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: isTablet ? 20 : 16),

        if (families.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isTablet ? 20 : 18),
            ),
            child: Text(
              'Hələlik ailə qeydiyyatı yoxdur.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: isTablet ? 16 : null,
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

                if (i != families.length - 1)
                  SizedBox(height: isTablet ? 14 : 12),
              ],
            ],
          ),
      ],
    );
  }
}
