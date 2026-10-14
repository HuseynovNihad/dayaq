import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/email_name_formatter.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key, this.onNotificationTap});

  final VoidCallback? onNotificationTap;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String _displayName = 'İstifadəçi';

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final email = await sl<TokenStorage>().getEmail();

      if (!mounted) return;

      setState(() {
        _displayName = EmailNameFormatter.format(email);
      });
    } catch (_) {
      // Email oxunmadıqda standart müraciət qalır.
    }
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Sabahınız xeyir,';
    if (hour < 18) return 'Günortanız xeyir,';
    return 'Axşamınız xeyir,';
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    final date = DateFormat('d MMMM yyyy', 'az').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: isTablet ? 22 : null,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: isTablet ? 6.h : 4.h),

                  Text(
                    _displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontSize: isTablet ? 32 : null,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: isTablet ? 20.h : 12.h),

            IconButton(
              onPressed: widget.onNotificationTap,
              tooltip: 'Bildirişlər',
              iconSize: isTablet ? 30 : 24,
              constraints: BoxConstraints(
                minWidth: isTablet ? 56 : 48,
                minHeight: isTablet ? 56 : 48,
              ),
              icon: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: isTablet ? 22 : 14,
              color: AppColors.textSecondary,
            ),

            SizedBox(width: isTablet ? 12.h : 8.h),

            Text(
              date,
              style: context.textTheme.labelMedium?.copyWith(
                fontSize: isTablet ? 15 : null,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
