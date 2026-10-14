import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../families/domain/entities/family_entity.dart';
import '../widgets/family_map_view.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key, required this.families});

  final List<FamilyEntity> families;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
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
        toolbarHeight: isTablet ? 72 : 56,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: isTablet ? 26 : 22,
          ),
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Qeydiyyat xəritəsi',
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: isTablet ? 22 : null,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FamilyMapView(
              families: validFamilies,
              fitAllMarkers: true,
              fitPadding: EdgeInsets.fromLTRB(
                isTablet ? 80 : 48,
                isTablet ? 80 : 48,
                isTablet ? 80 : 48,
                isTablet ? 190 : 150,
              ),
            ),
          ),

          Positioned(
            left: isTablet ? 24 : 16,
            right: isTablet ? 24 : 16,
            bottom: isTablet ? 24 : 16,
            child: SafeArea(
              top: false,
              child: Center(
                heightFactor: 1,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 560),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 18,
                    vertical: isTablet ? 20 : 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
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
                        width: isTablet ? 56 : 44,
                        height: isTablet ? 56 : 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF2D6),
                          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                          size: isTablet ? 30 : 25,
                        ),
                      ),
  
                      SizedBox(width: isTablet ? 16 : 12),
  
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Xəritədə qeydiyyatlar',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontSize: isTablet ? 16 : null,
                                color: AppColors.textSecondary,
                              ),
                            ),
  
                            SizedBox(height: isTablet ? 6 : 3),
  
                            Text(
                              '${validFamilies.length} ailə',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontSize: isTablet ? 22 : null,
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
                        size: isTablet ? 28 : 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
