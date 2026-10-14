import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/profile_user_card.dart';
import '../widgets/profile_settings_section.dart';
import '../widgets/profile_logout_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
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

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthLogoutSuccess || current is AuthLogoutFailure,
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          context.go(AppRoutes.login);
        }

        if (state is AuthLogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 28 : 20.w,
                  isTablet ? 36 : 26.h,
                  isTablet ? 28 : 20.w,
                  isTablet ? 40 : 32.h,
                ),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileUserCard(email: _email),
                SizedBox(height: isTablet ? 32 : 26.h),
                ProfileSettingsSection(
                  onAboutTap: () => context.push(AppRoutes.about),
                  onTermConditionsTap: () =>
                      context.push(AppRoutes.termConditions),
                  onRulesTap: () => context.push(AppRoutes.rules),
                ),
                SizedBox(height: isTablet ? 32 : 26.h),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) =>
                      previous is AuthLogoutLoading ||
                      current is AuthLogoutLoading,
                  builder: (context, state) {
                    final isLoading = state is AuthLogoutLoading;

                    return ProfileLogoutButton(
                      isLoading: isLoading,
                      onLogout: isLoading ? null : () => _handleLogout(context),
                    );
                  },
                ),
                ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
