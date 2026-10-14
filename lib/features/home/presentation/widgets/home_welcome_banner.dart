import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class HomeWelcomeBanner extends StatelessWidget {
  const HomeWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 22 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF0DF), Color(0xFFFFE2B3)],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isTablet ? 56 : 44,
            height: isTablet ? 56 : 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.homeBanner,
              width: isTablet ? 24 : 16,
              height: isTablet ? 24 : 16,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: isTablet ? 18 : 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ailələrə göstərilən dəstəyi birlikdə idarə edək.',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: isTablet ? 22 : null,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: isTablet ? 10 : 6),

                Text(
                  'Hər bir qeydiyyat cəmiyyətdə daha sağlam '
                  'və rifah dolu gələcəyə atılan addımdır.',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: isTablet ? 16 : null,
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
