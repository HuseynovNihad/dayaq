import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/storage/token_storage.dart';
import '../widgets/profile_user_card.dart';
import '../widgets/profile_settings_section.dart';
import '../widgets/profile_logout_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.onAccountTap,
    this.onSecurityTap,
    this.onNotificationsTap,
    this.onLogout,
  });

  final VoidCallback? onAccountTap;
  final VoidCallback? onSecurityTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onLogout;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    try {
      final email = await sl<TokenStorage>().getEmail();

      if (!mounted) return;

      setState(() {
        _email = email?.trim();
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _email = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileUserCard(email: _email),
              SizedBox(height: 26.h),

              ProfileSettingsSection(
                onAboutTap: () => context.push(AppRoutes.about),
                onTermConditionsTap: () =>
                    context.push(AppRoutes.termConditions),
                onRulesTap: () => context.push(AppRoutes.rules),
              ),

              SizedBox(height: 26.h),
              ProfileLogoutButton(onLogout: widget.onLogout),
            ],
          ),
        ),
      ),
    );
  }
}
