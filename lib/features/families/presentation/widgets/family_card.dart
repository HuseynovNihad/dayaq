import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/family_entity.dart';

class FamilyCard extends StatelessWidget {
  const FamilyCard({super.key, required this.family, this.onTap});

  final FamilyEntity family;
  final VoidCallback? onTap;

  String get _initials {
    final parts = family.nameSurname
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }

  Color get _avatarColor {
    return switch (family.id.abs() % 3) {
      0 => const Color(0xFFFFDDA4),
      1 => const Color(0xFFDFE1FF),
      _ => const Color(0xFFFFE8C5),
    };
  }

  ({String label, Color background, Color foreground}) get _statusStyle {
    final status = family.status.trim().toLowerCase();

    return switch (status) {
      'active' || 'active_help' || 'aktiv yardım' => (
        label: 'Aktiv yardım',
        background: const Color(0xFFE2E4FF),
        foreground: const Color(0xFF273D91),
      ),
      'pending' || 'baxışda' || 'yoxlamada' || 'gözlənilir' => (
        label: 'Gözlənilir',
        background: const Color(0xFFFFE8BD),
        foreground: const Color(0xFF80602B),
      ),
      'uyğunluq təsdiqləndi' || 'approved' || 'təsdiqlənib' => (
        label: status == 'uyğunluq təsdiqləndi' ? family.status.trim() : 'Təsdiqlənib',
        background: const Color(0xFFE1F5E8),
        foreground: const Color(0xFF217A43),
      ),
      'uyğunluq təsdiqlənmədi' => (
        label: family.status.trim(),
        background: const Color(0xFFFDE8E7),
        foreground: const Color(0xFFB42318),
      ),
      'registered' || 'qeydə alınıb' => (
        label: 'Qeydə alınıb',
        background: const Color(0xFFEAE7E3),
        foreground: const Color(0xFF5E5140),
      ),
      _ => (
        label: family.status.trim(),
        background: const Color(0xFFF2F0ED),
        foreground: const Color(0xFF62594D),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final status = _statusStyle;
    final registerNumber = family.registerNumber.trim();
    final region = family.region.trim();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(isTablet ? 20 : 18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 18.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isTablet ? 20 : 16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isTablet ? 20 : 18.r),
            border: Border.all(color: const Color(0xFFF1EFEC)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: isTablet ? 62 : 52.r,
                    height: isTablet ? 62 : 52.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _avatarColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _initials,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: isTablet ? 23 : null,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2C2115),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          family.nameSurname,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: isTablet ? 19 : null,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (registerNumber.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            '№ $registerNumber',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: isTablet ? 14 : null,
                              color: const Color(0xFF897C6D),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: isTablet ? 26 : 22.r,
                    color: const Color(0xFF8B7C69),
                  ),
                ],
              ),
              if (status.label.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: status.background,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Text(
                      status.label,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: isTablet ? 14 : null,
                        color: status.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              if (region.isNotEmpty || family.createdAt != null) ...[
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F5F3),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Row(
                    children: [
                      if (region.isNotEmpty) ...[
                        Icon(
                          Icons.location_on_outlined,
                          size: isTablet ? 21 : 18.r,
                          color: const Color(0xFF897C6D),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            region,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: isTablet ? 14 : null,
                              color: const Color(0xFF62584D),
                            ),
                          ),
                        ),
                      ],
                      if (family.createdAt != null) ...[
                        if (region.isNotEmpty) SizedBox(width: 10.w),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: isTablet ? 19 : 16.r,
                          color: const Color(0xFF897C6D),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          DateFormat('dd.MM.yyyy').format(family.createdAt!),
                          style: textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF897C6D),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
