import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/campaigns/presentation/pages/campaigns_page.dart';
import '../../features/donations/presentation/pages/donations_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../widgets/app_button.dart';
import '../widgets/app_empty_state.dart';
import 'app_routes.dart';

GoRouter createAppRouter({String initialLocation = AppRoutes.login}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.campaigns,
                builder: (context, state) => const CampaignsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.donations,
                builder: (context, state) => const DonationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: AppEmptyState(
            title: 'Səhifə tapılmadı',
            message: 'Giriş səhifəsinə qayıda bilərsiniz.',
            action: AppButton(
              label: 'Giriş səhifəsinə qayıt',
              onPressed: () => context.go(AppRoutes.login),
            ),
          ),
        ),
      );
    },
  );
}
