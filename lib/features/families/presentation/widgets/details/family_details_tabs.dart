import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';

class FamilyDetailsTabs extends StatelessWidget {
  const FamilyDetailsTabs({
    super.key,
    required this.selectedIndex,
    required this.memberCount,
    required this.documentCount,
    required this.onChanged,
  });
  final int selectedIndex;
  final int? memberCount;
  final int? documentCount;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    final titles = [
      'Ümumi',
      'Üzvlər${memberCount == null ? '' : ' ($memberCount)'}',
      'Maliyyə',
      'Sənədlər${documentCount == null ? '' : ' ($documentCount)'}',
    ];
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Row(
        children: List.generate(titles.length, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: Material(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
              child: InkWell(
                onTap: () => onChanged(index),
                borderRadius: BorderRadius.circular(10.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    titles[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: selected
                          ? AppColors.textPrimary
                          : const Color(0xFF6C6C6C),
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
