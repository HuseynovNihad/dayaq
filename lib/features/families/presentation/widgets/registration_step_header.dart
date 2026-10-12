import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistrationStepHeader extends StatelessWidget {
  const RegistrationStepHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 7,
    this.onCancel,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFF4B033);

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 28.r,
              height: 28.r,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFDEA2),
              ),
              child: Text(
                '$currentStep',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Addım $currentStep / $totalSteps',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF514438),
                ),
              ),
            ),
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Ləğv et',
                style: TextStyle(
                  color: const Color(0xFFD32F2F),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: List.generate(totalSteps, (index) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1 ? 0 : 5.w,
                ),
                height: 7.h,
                decoration: BoxDecoration(
                  color: index < currentStep
                      ? primary
                      : const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
