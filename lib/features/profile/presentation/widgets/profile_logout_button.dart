import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_alert_dialog.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key, this.onLogout, this.isLoading = false});

  final VoidCallback? onLogout;
  final bool isLoading;

  Future<void> _confirmLogout(BuildContext context) async {
    if (isLoading || onLogout == null) return;

    final confirmed = await AppAlertDialog.showConfirmation(
      context: context,
      title: 'Sistemdən çıxış',
      message: 'Hesabınızdan çıxış etmək istədiyinizə əminsiniz?',
      confirmLabel: 'Çıxış et',
      cancelLabel: 'Ləğv et',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      onLogout?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    const logoutColor = Color(0xFFD71920);

    return Material(
      color: const Color(0xFFFDE9EA),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: isLoading || onLogout == null
            ? null
            : () => _confirmLogout(context),
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: logoutColor,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        size: 20.r,
                        color: logoutColor,
                      ),
                      SizedBox(width: 9.w),
                      Text(
                        'Sistemdən çıxış',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: logoutColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
