import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../families/domain/entities/family_entity.dart';
import '../widgets/family_map_view.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key, required this.families});

  final List<FamilyEntity> families;

  @override
  Widget build(BuildContext context) {
    final validFamilies = families
        .where(FamilyMapView.hasValidCoordinates)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Qeydiyyat xəritəsi',
          style: context.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FamilyMapView(families: validFamilies, fitAllMarkers: true),
          ),

          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 24.h,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2D6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 25.r,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Xəritədə qeydiyyatlar',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),

                          SizedBox(height: 3.h),

                          Text(
                            '${validFamilies.length} ailə',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      Icons.map_outlined,
                      color: AppColors.primary,
                      size: 24.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
