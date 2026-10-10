import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../families/domain/entities/family_entity.dart';

class HomeRecentFamilyCard extends StatelessWidget {
  const HomeRecentFamilyCard({super.key, required this.family, this.onTap});

  final FamilyEntity family;
  final VoidCallback? onTap;

  Color _statusBackgroundColor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'approved':
      case 'təsdiqlənib':
        return const Color(0xFFDDE2FF);

      case 'pending':
      case 'baxışda':
        return const Color(0xFFFFE0A8);

      case 'registered':
      case 'qeydə alınıb':
        return const Color(0xFFEAE7E3);

      default:
        return const Color(0xFFF1F0EE);
    }
  }

  Color _statusTextColor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'approved':
      case 'təsdiqlənib':
        return const Color(0xFF233B9B);

      case 'pending':
      case 'baxışda':
        return const Color(0xFF79500A);

      default:
        return const Color(0xFF5E5140);
    }
  }

  String _statusLabel(String status) {
    switch (status.trim().toLowerCase()) {
      case 'approved':
        return 'Təsdiqlənib';

      case 'pending':
        return 'Baxışda';

      case 'registered':
        return 'Qeydə alınıb';

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = family.status.trim();

    final details = [
      if (family.registerNumber.trim().isNotEmpty)
        'Qeydiyyat № ${family.registerNumber}',
      if (family.region.trim().isNotEmpty) family.region,
      if (family.createdAt != null)
        DateFormat('dd.MM.yyyy').format(family.createdAt!),
    ].join(' • ');

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFF0ECE7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          family.nameSurname,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        if (status.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBackgroundColor(status),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Text(
                              _statusLabel(status),
                              style: context.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _statusTextColor(status),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w),

                  Icon(
                    Icons.chevron_right_rounded,
                    size: 24.r,
                    color: const Color(0xFF8B7B67),
                  ),
                ],
              ),

              if (details.isNotEmpty) ...[
                SizedBox(height: 8.h),

                Text(
                  details,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
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
