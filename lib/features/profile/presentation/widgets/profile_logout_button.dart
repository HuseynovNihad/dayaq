import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key, this.onLogout});

  final VoidCallback? onLogout;

  Future<void> _confirmLogout(BuildContext context) async {
    if (onLogout == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Sistemdən çıxış',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Hesabınızdan çıxış etmək istədiyinizə əminsiniz?',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Ləğv et'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Çıxış et',
                style: TextStyle(
                  color: Color(0xFFE02020),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      onLogout?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFDE9EA),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onLogout == null ? null : () => _confirmLogout(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          height: 52.h,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                size: 20.r,
                color: const Color(0xFFD71920),
              ),
              SizedBox(width: 9.w),
              Text(
                'Sistemdən çıxış',
                style: context.textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFD71920),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
