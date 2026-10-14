import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileContentCard extends StatelessWidget {
  const ProfileContentCard({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 28 : 20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 18.r),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: SelectableText(
        content,
        style: context.textTheme.bodyMedium?.copyWith(
          fontSize: isTablet ? 16 : null,
          color: AppColors.textPrimary,
          height: 1.7,
        ),
      ),
    );
  }
}
