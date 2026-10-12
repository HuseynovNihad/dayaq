import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    super.key,
    this.onAboutTap,
    this.onTermConditionsTap,
    this.onRulesTap,
  });

  final VoidCallback? onAboutTap;
  final VoidCallback? onTermConditionsTap;
  final VoidCallback? onRulesTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            'MƏLUMAT',
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF707070),
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFE1E1E1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 8.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Column(
            children: [
              _SettingsItem(
                icon: Icons.volunteer_activism_outlined,
                iconColor: AppColors.primary,
                title: 'Haqqımızda',
                onTap: onAboutTap,
              ),
              _SettingsItem(
                icon: Icons.description_outlined,
                iconColor: AppColors.primary,
                title: 'Şərtlər və Qaydalar',
                onTap: onTermConditionsTap,
              ),
              _SettingsItem(
                icon: Icons.menu_book_outlined,
                iconColor: AppColors.primary,
                title: 'İstifadə qaydaları',
                onTap: onRulesTap,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 17.h),
              child: Row(
                children: [
                  Icon(icon, size: 21.r, color: iconColor),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      title,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 21.r,
                      color: const Color(0xFFB7B7B7),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 15.w,
            endIndent: 15.w,
            color: const Color(0xFFF0F0F0),
          ),
      ],
    );
  }
}
