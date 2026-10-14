import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../families/domain/entities/family_entity.dart';

class HomeRecentFamilyCard extends StatelessWidget {
  const HomeRecentFamilyCard({super.key, required this.family, this.onTap});

  final FamilyEntity family;
  final VoidCallback? onTap;

  // Status background rəngləri
  Color _statusBackgroundColor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'uyğunluq təsdiqləndi':
      case 'approved':
      case 'təsdiqlənib':
        return const Color(0xFFE1F5E8);

      case 'uyğunluq təsdiqlənmədi':
        return const Color(0xFFFDE8E7);

      case 'gözlənilir':
      case 'pending':
      case 'baxışda':
        return const Color(0xFFFFF1D6);

      case 'registered':
      case 'qeydə alınıb':
        return const Color(0xFFEAE7E3);

      default:
        return const Color(0xFFF1F0EE);
    }
  }

  // Status mətn rəngləri
  Color _statusTextColor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'uyğunluq təsdiqləndi':
      case 'approved':
      case 'təsdiqlənib':
        return const Color(0xFF217A43);

      case 'uyğunluq təsdiqlənmədi':
        return const Color(0xFFB42318);

      case 'gözlənilir':
      case 'pending':
      case 'baxışda':
        return const Color(0xFF946200);

      default:
        return const Color(0xFF5E5140);
    }
  }

  // Backend statuslarının göstərilməsi
  String _statusLabel(String status) {
    switch (status.trim().toLowerCase()) {
      case 'approved':
        return 'Təsdiqlənib';

      case 'pending':
        return 'Baxışda';

      case 'registered':
        return 'Qeydə alınıb';

      default:
        return status.trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    final status = family.status.trim();

    final details = [
      if (family.registerNumber.trim().isNotEmpty)
        'Qeydiyyat № ${family.registerNumber}',
      if (family.region.trim().isNotEmpty) family.region,
      if (family.createdAt != null)
        DateFormat('dd.MM.yyyy').format(family.createdAt!),
    ].join(' • ');

    final borderRadius = BorderRadius.circular(isTablet ? 20 : 18);

    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: isTablet ? 12 : 8,
                      runSpacing: isTablet ? 8 : 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Ailə adı
                        Text(
                          family.nameSurname,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontSize: isTablet ? 20 : null,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        // Status badge
                        if (status.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 14 : 10,
                              vertical: isTablet ? 7 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBackgroundColor(status),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              _statusLabel(status),
                              style: context.textTheme.labelSmall?.copyWith(
                                fontSize: isTablet ? 13 : null,
                                fontWeight: FontWeight.w600,
                                color: _statusTextColor(status),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(width: isTablet ? 12 : 8),

                  Icon(
                    Icons.chevron_right_rounded,
                    size: isTablet ? 28 : 24,
                    color: const Color(0xFF8B7B67),
                  ),
                ],
              ),

              // Qeydiyyat nömrəsi, region və tarix
              if (details.isNotEmpty) ...[
                SizedBox(height: isTablet ? 12 : 8),

                Text(
                  details,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: isTablet ? 15 : null,
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
