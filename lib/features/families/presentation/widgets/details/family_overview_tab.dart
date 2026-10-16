import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/family_details_entity.dart';
import '../../../domain/entities/family_entity.dart';
import '../../../data/models/family_details_model.dart';
import 'detail_common_widgets.dart';

class FamilyOverviewTab extends StatelessWidget {
  const FamilyOverviewTab({required this.family, required this.details});
  final FamilyEntity family;
  final FamilyDetailsEntity details;
  @override
  Widget build(BuildContext context) {
    final region = details.region.trim().isNotEmpty
        ? details.region
        : family.region;
    final lat = details.lat ?? family.lat;
    final lng = details.lng ?? family.lng;
    final hasCoordinates = lat != null && lng != null;
    final phone2 = details is FamilyDetailsModel
        ? ((details as FamilyDetailsModel).phone2 ?? '').trim()
        : '';
    return Column(
      children: [
        DetailCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DetailSectionTitle('AİLƏ VƏ ƏLAQƏ MƏLUMATLARI'),
              SizedBox(height: 8.h),
              DetailInfoRow(
                label: 'Əsas telefon nömrəsi',
                value: family.phone.trim().isEmpty
                    ? 'Məlumat yoxdur'
                    : family.phone,
              ),
              if (phone2.isNotEmpty)
                DetailInfoRow(
                  label: 'Əlavə telefon nömrəsi',
                  value: phone2,
                ),
              DetailInfoRow(
                label: 'Qeydiyyat nömrəsi',
                value: family.registerNumber.trim().isEmpty
                    ? 'Məlumat yoxdur'
                    : family.registerNumber,
              ),
              DetailInfoRow(
                label: 'Ailə üzvləri',
                value: '${details.members.length} nəfər',
                showDivider: false,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        DetailCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: DetailSectionTitle('FAKTİKİ ÜNVAN')),
                  Flexible(
                    child: Text(
                      region,
                      maxLines: 2,
                      textAlign: TextAlign.right,
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              if (details.members.any(
                (member) => member.address.trim().isNotEmpty,
              ))
                Text(
                  details.members
                      .firstWhere((member) => member.address.trim().isNotEmpty)
                      .address,
                  style: context.textTheme.bodyMedium,
                ),
              SizedBox(height: 12.h),
              Container(
                height: 145.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F9),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFE0E4E9)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42.r,
                      height: 42.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB42C),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.black,
                        size: 25.r,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      hasCoordinates
                          ? '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}'
                          : 'GPS koordinatları mövcud deyil',
                      style: context.textTheme.bodySmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 15 : null,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasCoordinates) ...[
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final uri = Uri.https('www.google.com', '/maps/search/', {
                        'api': '1',
                        'query': '$lat,$lng',
                      });
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: Icon(
                      Icons.map_rounded,
                      size: 19.r,
                      color: const Color(0xFF173DA8),
                    ),
                    label: const Text('Xəritədə aç və naviqasiya et'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: Color(0xFFD2D2D2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
