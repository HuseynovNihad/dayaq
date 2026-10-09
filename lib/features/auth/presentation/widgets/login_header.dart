import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class LoginHeader extends StatelessWidget with SU {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppAssets.logo,
          width: 104.r,
          height: 104.r,
          fit: BoxFit.contain,
          semanticLabel: 'Dayaq loqosu',
        ),
        Text(
          'Xoş gəlmisiniz',
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Ailələrin qeydiyyatı və idarə edilməsi sistemi',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
