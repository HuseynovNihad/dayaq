import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class HomeWelcomeBanner extends StatelessWidget {
  const HomeWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF0DF), Color(0xFFFFE2B3)],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.homeBanner,
              width: 16.r,
              height: 16.r,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ailələrə göstərilən dəstəyi birlikdə idarə edək.',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Hər bir qeydiyyat cəmiyyətdə daha sağlam və rifah dolu gələcəyə atılan addımdır.',
                  style: context.textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    color: const Color(0xFF72501C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
