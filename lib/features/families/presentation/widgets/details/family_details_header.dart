import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/family_details_entity.dart';
import '../../../domain/entities/family_entity.dart';
import 'detail_common_widgets.dart';

class FamilyDetailsHeader extends StatelessWidget {
  const FamilyDetailsHeader({
    required this.family,
    required this.showActions,
    required this.details,
  });
  final FamilyEntity family;
  final FamilyDetailsEntity? details;
  final bool showActions;
  String get _initials {
    final parts = family.nameSurname
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
  String get _statusLabel {
    return switch (family.status.trim().toLowerCase()) {
      'active' || 'active_help' => 'Aktiv yardım',
      'pending' || 'gözlənilir' => 'Gözlənilir',
      'approved' => 'Təsdiqlənib',
      'registered' => 'Qeydə alınıb',
      _ => family.status,
    };
  }
  Future<void> _call(BuildContext context) async {
    final phone = family.phone.trim();
    if (phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone);
    if (!await launchUrl(uri) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zəng başlatmaq mümkün olmadı.')),
      );
    }
  }
  Future<void> _openMap(BuildContext context) async {
    final lat = details?.lat ?? family.lat;
    final lng = details?.lng ?? family.lng;
    if (lat == null || lng == null) return;
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '$lat,$lng',
    });
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xəritəni açmaq mümkün olmadı.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final date = family.createdAt == null
        ? ''
        : DateFormat('dd.MM.yyyy').format(family.createdAt!);
    final hasPhone = family.phone.trim().isNotEmpty;
    final hasCoordinates =
        (details?.lat ?? family.lat) != null &&
        (details?.lng ?? family.lng) != null;
    return DetailCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52.r,
                height: 52.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFDDA4),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _initials,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      family.nameSurname,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      [
                        if (family.registerNumber.trim().isNotEmpty)
                          'Qeydiyyat № ${family.registerNumber}',
                        if (date.isNotEmpty) date,
                      ].join(' • '),
                      maxLines: 2,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_statusLabel.trim().isNotEmpty) ...[
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FF),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: const Color(0xFFC7D5FF)),
                ),
                child: Text(
                  _statusLabel,
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1745B7),
                  ),
                ),
              ),
            ),
          ],
          if (showActions && (hasPhone || hasCoordinates)) ...[
            SizedBox(height: 14.h),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            SizedBox(height: 10.h),
            Row(
              children: [
                if (hasPhone)
                  Expanded(
                    child: _HeaderAction(
                      label: 'Zəng et',
                      icon: Icons.call_rounded,
                      background: const Color(0xFFF2F2F2),
                      onTap: () => _call(context),
                    ),
                  ),
                if (hasPhone && hasCoordinates) SizedBox(width: 10.w),
                if (hasCoordinates)
                  Expanded(
                    child: _HeaderAction(
                      label: 'Xəritədə göstər',
                      icon: Icons.navigation_rounded,
                      background: const Color(0xFFFFF0CB),
                      onTap: () => _openMap(context),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.label,
    required this.icon,
    required this.background,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color background;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17.r, color: const Color(0xFF173DA8)),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
