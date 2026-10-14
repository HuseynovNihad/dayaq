import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class LoginAccessNotice extends StatelessWidget with SU {
  const LoginAccessNotice({super.key, this.isTablet = false});

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 18 : AppSpacing.md),
      decoration: BoxDecoration(
        color: Color(0xFFF5F3F3),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: isTablet ? 23 : 22.r,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: isTablet ? 14 : AppSpacing.md),
          Expanded(
            child: Text(
              'Yalnız səlahiyyətli xeyriyyə təşkilatı əməkdaşları '
              'və könüllülər üçün nəzərdə tutulub.',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: isTablet ? 14 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
