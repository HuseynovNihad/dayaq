import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/family_details_entity.dart';
import 'detail_common_widgets.dart';

class FamilyMembersTab extends StatelessWidget {
  const FamilyMembersTab({super.key, required this.details});
  final FamilyDetailsEntity details;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Qeydiyyatda olan ailə üzvləri',
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 20 : null,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 14.h),
        if (details.members.isEmpty)
          const DetailEmptySection(
            icon: Icons.people_outline_rounded,
            message: 'Ailə üzvləri barədə məlumat yoxdur.',
          )
        else
          ...details.members.map(
            (member) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _MemberCard(member: member),
            ),
          ),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});
  final FamilyDetailMemberEntity member;
  String get _initials {
    final parts = member.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  int? get _age {
    final birthday = member.birthday;
    if (birthday == null) return null;
    final now = DateTime.now();
    var age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age < 0 ? null : age;
  }

  @override
  Widget build(BuildContext context) {
    final birthday = member.birthday;
    final birthdayText = birthday == null
        ? null
        : '${DateFormat('dd.MM.yyyy').format(birthday)}'
              '${_age == null ? '' : ' ($_age yaş)'}';
    return DetailCard(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: const Color(0xFFE7E7E7),
                child: Text(
                  _initials,
                  style: context.textTheme.titleSmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 20 : null,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: context.textTheme.titleSmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 20 : null,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (member.familyMemberType.trim().isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0CB),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          _familyMemberTypeLabel(member.familyMemberType),
                          style: context.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (birthdayText != null)
                Flexible(
                  child: Text(
                    birthdayText,
                    textAlign: TextAlign.right,
                    style: context.textTheme.bodySmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 15 : null,
                      color: const Color(0xFF777777),
                    ),
                  ),
                ),
            ],
          ),
          if (member.phone.trim().isNotEmpty ||
              member.address.trim().isNotEmpty) ...[
            SizedBox(height: 12.h),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            SizedBox(height: 10.h),
            if (member.phone.trim().isNotEmpty)
              _MemberInfo(
                icon: Icons.call_rounded,
                color: const Color(0xFF1642B7),
                value: member.phone,
              ),
            if (member.address.trim().isNotEmpty) ...[
              SizedBox(height: 8.h),
              _MemberInfo(
                icon: Icons.location_on_rounded,
                color: const Color(0xFFFFAE22),
                value: member.address,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _MemberInfo extends StatelessWidget {
  const _MemberInfo({
    required this.icon,
    required this.color,
    required this.value,
  });
  final IconData icon;
  final Color color;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17.r, color: color),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 16 : null,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

String _familyMemberTypeLabel(String value) {
  return switch (value.trim()) {
    '0' => 'Ana',
    '1' => 'Övlad',
    '2' => 'Oğlu',
    '3' => 'Qızı',
    '4' => 'Nənə',
    '5' => 'Baba',
    '6' => 'Nəvə',
    _ => value.trim().isEmpty ? 'Bilinmir' : value,
  };
}
