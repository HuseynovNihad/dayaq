import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE3E3E3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: const Color(0xFF737373),
      ),
    );
  }
}

class DetailInfoRow extends StatelessWidget {
  const DetailInfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });
  final String label;
  final String value;
  final bool showDivider;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF777777),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}

class DetailEmptySection extends StatelessWidget {
  const DetailEmptySection({required this.icon, required this.message});
  final IconData icon;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 38.r, color: const Color(0xFFA7A7A7)),
          SizedBox(height: 10.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }
}

