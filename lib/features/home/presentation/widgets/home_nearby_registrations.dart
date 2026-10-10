import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../families/domain/entities/family_entity.dart';
import '../../../map/presentation/widgets/family_map_view.dart';

class HomeNearbyRegistrations extends StatelessWidget {
  const HomeNearbyRegistrations({
    super.key,
    required this.families,
    this.onOpenMap,
  });

  final List<FamilyEntity> families;
  final VoidCallback? onOpenMap;

  bool _hasValidCoordinates(FamilyEntity family) {
    final lat = family.lat;
    final lng = family.lng;

    return lat != null &&
        lng != null &&
        lat.isFinite &&
        lng.isFinite &&
        lat >= -90 &&
        lat <= 90 &&
        lng >= -180 &&
        lng <= 180;
  }

  @override
  Widget build(BuildContext context) {
    final mappedFamilies = families.where(_hasValidCoordinates).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yaxınlıqdakı qeydiyyatlar',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: 6.h),

        Text(
          'Xəritədə qeydiyyatların yerləşməsi',
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        SizedBox(height: 16.h),

        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFF0ECE7)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 200.h,
                width: double.infinity,
                child: FamilyMapView(families: mappedFamilies),
              ),

              Padding(
                padding: EdgeInsets.all(14.r),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20.r,
                      color: AppColors.primary,
                    ),

                    SizedBox(width: 8.w),

                    Expanded(
                      child: Text(
                        '${mappedFamilies.length} qeydiyyat xəritədə',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: onOpenMap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Xəritəni aç',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF3954D8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12.r,
                            color: const Color(0xFF3954D8),
                          ),
                        ],
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
