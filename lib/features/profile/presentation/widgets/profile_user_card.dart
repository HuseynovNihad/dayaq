import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({super.key, required this.email});

  final String? email;

  String get _initials {
    final value = email?.trim() ?? '';
    if (value.isEmpty) return '?';

    return value.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final displayEmail = email?.trim().isNotEmpty == true
        ? email!
        : 'Email məlumatı yoxdur';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profil və Tənzimləmələr',
          style: textTheme.headlineSmall?.copyWith(
            fontSize: isTablet ? 28 : null,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 28 : 24.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isTablet ? 24 : 18.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isTablet ? 20 : 18.r),
            border: Border.all(color: const Color(0xFFE1E1E1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 10.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 68 : 58.r,
                height: isTablet ? 68 : 58.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _initials,
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: isTablet ? 26 : null,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: isTablet ? 20 : 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hesab məlumatları',
                      style: textTheme.labelMedium?.copyWith(
                        fontSize: isTablet ? 15 : null,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      displayEmail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: isTablet ? 19 : null,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
