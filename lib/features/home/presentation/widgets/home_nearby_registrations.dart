import 'package:flutter/material.dart';

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
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    final mappedFamilies = families.where(_hasValidCoordinates).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bölmə başlığı
        Text(
          'Yaxınlıqdakı qeydiyyatlar',
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: isTablet ? 22 : null,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: isTablet ? 8 : 6),

        // Açıqlama mətni
        Text(
          'Xəritədə qeydiyyatların yerləşməsi',
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: isTablet ? 16 : null,
            color: AppColors.textSecondary,
          ),
        ),

        SizedBox(height: isTablet ? 20 : 16),

        // Xəritə kartı
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isTablet ? 20 : 18),
            border: Border.all(color: const Color(0xFFF0ECE7)),
          ),
          child: Column(
            children: [
              // Xəritə
              SizedBox(
                height: isTablet ? 280 : 200,
                width: double.infinity,
                child: FamilyMapView(families: mappedFamilies),
              ),

              // Xəritənin alt məlumat hissəsi
              Padding(
                padding: EdgeInsets.all(isTablet ? 18 : 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: isTablet ? 26 : 20,
                      color: AppColors.primary,
                    ),

                    SizedBox(width: isTablet ? 12 : 8),

                    Expanded(
                      child: Text(
                        '${mappedFamilies.length} qeydiyyat xəritədə',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: isTablet ? 16 : null,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(width: isTablet ? 8 : 4),

                    TextButton(
                      onPressed: onOpenMap,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 10 : 6,
                          vertical: isTablet ? 10 : 8,
                        ),
                        minimumSize: const Size(0, 44),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Xəritəni aç',
                            style: context.textTheme.labelMedium?.copyWith(
                              fontSize: isTablet ? 15 : null,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3954D8),
                            ),
                          ),

                          SizedBox(width: isTablet ? 8 : 4),

                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: isTablet ? 15 : 12,
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
