import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistrationStepHeader extends StatelessWidget {
  const RegistrationStepHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 7,
    this.onSave,
    this.onCancel,
    this.isSaving = false,
    this.actionsEnabled = true,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final bool isSaving;
  final bool actionsEnabled;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFF4B033);
    final progress = totalSteps > 0
        ? (currentStep / totalSteps).clamp(0.0, 1.0).toDouble()
        : 0.0;

    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: isTablet ? 38 : 34.r,
              height: isTablet ? 38 : 34.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEAC8),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Text(
                '$currentStep',
                style: TextStyle(
                  fontSize: isTablet ? 17 : 15.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF765016),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '/ $totalSteps',
              style: TextStyle(
                color: const Color(0xFF827A71),
                fontSize: isTablet ? 17 : 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: actionsEnabled && !isSaving ? onSave : null,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: const Color(0xFF856021),
                backgroundColor: const Color(0xFFFFF2DE),
                disabledForegroundColor: const Color(
                  0xFF856021,
                ).withValues(alpha: 0.5),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 16 : 12.w,
                  vertical: isTablet ? 11 : 9.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.r),
                ),
              ),
              icon: isSaving
                  ? SizedBox(
                      width: 17.r,
                      height: 17.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF856021),
                      ),
                    )
                  : Icon(
                      Icons.bookmark_outline_rounded,
                      size: isTablet ? 22 : 19.sp,
                    ),
              label: Text(
                isSaving ? 'Saxlanılır' : 'Yadda saxla',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            TextButton(
              onPressed: actionsEnabled && !isSaving ? onCancel : null,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: const Color(0xFF9B6C68),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 12 : 9.w,
                  vertical: isTablet ? 11 : 9.h,
                ),
              ),
              child: Text(
                'Ləğv et',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 12 : 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(99.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: isTablet ? 7 : 6.h,
            backgroundColor: const Color(0xFFEDE9E2),
            valueColor: const AlwaysStoppedAnimation<Color>(primary),
          ),
        ),
      ],
    );
  }
}
